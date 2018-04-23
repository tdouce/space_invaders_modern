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
    @fortifications = @world.level.player_fortifications
  end

  def update
    if arrow_left?
      @world.level.players.each {|p| p.move_left }
    end

    if arrow_right?
      @world.level.players.each {|p| p.move_right }
    end

    @world.level.players.each {|p| p.move }

    @world.level.players.each {|p| p.lasers.each {|laser| laser.go } }
    @world.level.aliens.each {|alien| alien.lasers.each {|laser| laser.go }}
    @world.level.aliens.each {|alien| alien.go }

    # Calculate score here (rather than #draw). calculating score in #draw causes things to be out-of-sync
    @world.calculate_score

    if !@world.end_of_game? && @world.level.won?
      @world.transition_to_next_level
    end

    unless @world.level.over?
      @world.level.aliens.each {|alien| alien.shoot_laser(calc_seconds)}

      # TODO: Move to level (or somewhere)
      @world.level.players.each do |p|
        @world.level.aliens = @world.level.aliens.reject do |alien|
          if p.shot_alien?(alien)
            @world.level.inc_kill_count
            true
          else
            false
          end
        end
      end

      @world.level.repopulate_aliens
    end

    @time_milli += update_interval
  end

  def draw
    @world.level.background_image.draw(0, 0, ZOrder::BACKGROUND)
    @world.level.aliens.each {|alien| alien.draw }

    unless @world.level.over?
      @world.level.players.each {|p| p.lasers.each {|laser| laser.draw } }
      @world.level.aliens.each {|alien| alien.lasers.each {|laser| laser.draw }}
    end

    @fortifications.draw
    @world.level.players.each do |p|
      p.draw(
        @world.level.aliens.map {|alien| alien.lasers}.flatten,
        calc_seconds
      )
    end

    @world.level.players.each do |p|
      p.lasers = p.lasers.select {|laser| inside_viewable_window?(laser.y) }
    end

    @world.level.aliens.each do |alien|
      alien.lasers = alien.lasers.select {|laser| inside_viewable_window?(laser.y) }
    end

    unless @world.level.over?
      @world.level.players.each do |p|
        @fortifications.assess_damage(p, @world.level.aliens)
      end
    end

    @font.draw("#{ @world.level.name }", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    @font.draw("Health: #{ @world.level.player_health }", 10, 33, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    @font.draw("Points: #{ @world.score }", 10, 55, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)

    if @world.end_of_game? && @world.level.won?
      @font.draw("Congratulations! You beat the game!", 315, 225, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    elsif @world.level.won?
      @font.draw("#{ @world.level.name} Complete!", 315, 225, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    elsif @world.level.lost?
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
        @world.level.players.each do |p|
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