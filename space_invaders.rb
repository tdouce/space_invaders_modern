require 'gosu'
require_relative 'player'
require_relative 'laser'
require_relative 'zorder'
require_relative 'alien/space_ship'
require_relative 'levels/level_one'

include Gosu
include ZOrder

class SpaceInvaders < Gosu::Window
  HEIGHT = 500
  WIDTH = 800

  attr_reader :player

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Space Invaders"

    @level = Levels::LevelOne.new
    @background_image = @level.background_image
    @player = Player.new(x: 320, y: 470)
    @alien_lasers = []
    @aliens = @level.aliens
    @time_milli = 0
    @font = Gosu::Font.new(20)
  end

  def update
    if arrow_left?
      player.move_left
    end

    if arrow_right?
      player.move_right
    end

    player.move

    @player.lasers.each {|laser| laser.go }
    @alien_lasers.each {|laser| laser.go }
    @aliens.each {|alien| alien.go }

    @aliens.each do |alien|
      if alien.time_to_shoot?(calc_seconds)
        @alien_lasers << alien.shoot_laser
      end
    end

    unless player.dead?
      @player.assess_damage(@alien_lasers, calc_seconds)
    end

    @time_milli += update_interval
  end

  def draw
    @background_image.draw(0, 0, ZOrder::BACKGROUND)
    @aliens.each {|alien| alien.draw }
    player.lasers.each {|laser| laser.draw }
    @alien_lasers.each {|laser| laser.draw }

    player.draw

    @player.lasers = player.lasers.select {|laser| inside_viewable_window?(laser.y) }
    @alien_lasers = @alien_lasers.select {|laser| inside_viewable_window?(laser.y) }

    @aliens = @aliens.reject {|alien| player.hit_alien?(alien) }

    @font.draw("Health: #{ player.health }", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    @font.draw("Points: #{ player.tally_score(@aliens) }", 10, 35, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)

    if player.dead?
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

  def arrow_right?
    Gosu.button_down?(Gosu::KB_RIGHT) || Gosu::button_down?(Gosu::GP_RIGHT)
  end

  def arrow_left?
    Gosu.button_down?(Gosu::KB_LEFT) || Gosu::button_down?(Gosu::GP_LEFT)
  end

  def button_down(id)
    case id
      when Gosu::KB_ESCAPE
        close
      when Gosu::KB_SPACE
        unless player.dead?
          player.shoot_laser
        end
      else
        super
    end
  end
end

SpaceInvaders.new.show