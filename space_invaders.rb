require 'gosu'
require_relative 'player'
require_relative 'laser'
require_relative 'zorder'
require_relative 'alien/space_ship'
require_relative 'levels/level_one'
require_relative 'controllable'
require_relative 'levels/world'

include Gosu
include ZOrder
include Controllable

class SpaceInvaders < Gosu::Window
  HEIGHT = 500
  WIDTH = 800

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Space Invaders"
    @world = Levels::World.new
    @level = @world.current_level
    @time_milli = 0
    @font = Gosu::Font.new(20)
    @fortifications = @level.player_fortifications
  end

  def update
    if arrow_left?
      @level.players.each {|p| p.move_left }
    end

    if arrow_right?
      @level.players.each {|p| p.move_right }
    end

    @level.players.each {|p| p.move }

    @level.players.each {|p| p.lasers.each {|laser| laser.go } }
    @level.aliens.each {|alien| alien.lasers.each {|laser| laser.go }}
    @level.aliens.each {|alien| alien.go }

    if !@world.end_of_game? && @level.won?
      @level = @world.transition_to_next_level
    end

    unless @level.over?
      @level.aliens.each {|alien| alien.shoot_laser(calc_seconds)}

      # TODO: Move to level (or somewhere)
      @level.players.each do |p|
        @level.aliens = @level.aliens.reject do |alien|
          if p.shot_alien?(alien)
            @level.inc_kill_count
            true
          else
            false
          end
        end
      end

      @level.repopulate_aliens
    end

    @time_milli += update_interval
  end

  def draw
    @level.background_image.draw(0, 0, ZOrder::BACKGROUND)
    @level.aliens.each {|alien| alien.draw }

    unless @level.over?
      @level.players.each {|p| p.lasers.each {|laser| laser.draw } }
      @level.aliens.each {|alien| alien.lasers.each {|laser| laser.draw }}
    end

    @fortifications.draw
    @level.players.each do |p|
      p.draw(
        @level.aliens.map {|alien| alien.lasers}.flatten,
        calc_seconds
      )
    end

    @level.players.each do |p|
      p.lasers = p.lasers.select {|laser| inside_viewable_window?(laser.y) }
    end

    @level.aliens.each do |alien|
      alien.lasers = alien.lasers.select {|laser| inside_viewable_window?(laser.y) }
    end

    unless @level.over?
      @level.players.each do |p|
        @fortifications.assess_damage(p, @level.aliens)
      end
    end

    @font.draw("Health: #{ @level.player_health }", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    @font.draw("Points: #{ @level.score }", 10, 35, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)

    if @level.lost?
      @font.draw("GAME OVER", 315, 225, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    end

    if @level.won?
      @font.draw("#{ @level.name} Complete!", 315, 225, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    end
  end

  private

  def calc_seconds
    if @time_milli > 1
      @time_milli / 1000
    else
      @time_milli
    end
  end

  def inside_viewable_window?(y)
    y >= 40 && y <= 470
  end

  def button_down(id)
    case id
      when Gosu::KB_ESCAPE
        close
      when Gosu::KB_SPACE
        @level.players.each do |p|
          unless p.dead?
            p.shoot_laser
          end
        end
      else
        super
    end
  end
end

SpaceInvaders.new.show