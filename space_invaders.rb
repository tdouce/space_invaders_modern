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
    @time_milli = 0
    @font = Gosu::Font.new(20)
    @fortifications = @world.current_level.player_fortifications
  end

  def update
    if arrow_left?
      @world.current_level.players.each {|p| p.move_left }
    end

    if arrow_right?
      @world.current_level.players.each {|p| p.move_right }
    end

    @world.current_level.players.each {|p| p.move }

    @world.current_level.players.each {|p| p.lasers.each {|laser| laser.go } }
    @world.current_level.aliens.each {|alien| alien.lasers.each {|laser| laser.go }}
    @world.current_level.aliens.each {|alien| alien.go }

    if !@world.end_of_game? && @world.current_level.won?
      @world.transition_to_next_level
    end

    unless @world.current_level.over?
      @world.current_level.aliens.each {|alien| alien.shoot_laser(calc_seconds)}

      # TODO: Move to level (or somewhere)
      @world.current_level.players.each do |p|
        @world.current_level.aliens = @world.current_level.aliens.reject do |alien|
          if p.shot_alien?(alien)
            @world.current_level.inc_kill_count
            true
          else
            false
          end
        end
      end

      @world.current_level.repopulate_aliens
    end

    @time_milli += update_interval
  end

  def draw
    @world.current_level.background_image.draw(0, 0, ZOrder::BACKGROUND)
    @world.current_level.aliens.each {|alien| alien.draw }

    unless @world.current_level.over?
      @world.current_level.players.each {|p| p.lasers.each {|laser| laser.draw } }
      @world.current_level.aliens.each {|alien| alien.lasers.each {|laser| laser.draw }}
    end

    @fortifications.draw
    @world.current_level.players.each do |p|
      p.draw(
        @world.current_level.aliens.map {|alien| alien.lasers}.flatten,
        calc_seconds
      )
    end

    @world.current_level.players.each do |p|
      p.lasers = p.lasers.select {|laser| inside_viewable_window?(laser.y) }
    end

    @world.current_level.aliens.each do |alien|
      alien.lasers = alien.lasers.select {|laser| inside_viewable_window?(laser.y) }
    end

    unless @world.current_level.over?
      @world.current_level.players.each do |p|
        @fortifications.assess_damage(p, @world.current_level.aliens)
      end
    end

    @font.draw("#{ @world.current_level.name }", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    @font.draw("Health: #{ @world.current_level.player_health }", 10, 33, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    @font.draw("Points: #{ @world.current_level.score }", 10, 55, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)

    if @world.end_of_game? && @world.current_level.won?
      @font.draw("Congratulations! You beat the game!", 315, 225, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    elsif @world.current_level.won?
      @font.draw("#{ @world.current_level.name} Complete!", 315, 225, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    elsif @world.current_level.lost?
      @font.draw("GAME OVER", 315, 225, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
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
        @world.current_level.players.each do |p|
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