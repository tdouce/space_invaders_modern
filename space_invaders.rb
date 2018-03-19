require 'gosu'
require_relative 'player'
require_relative 'laser'
require_relative 'zorder'
require_relative 'alien/space_ship'

include Gosu
include ZOrder

class SpaceInvaders < Gosu::Window
  HEIGHT = 500
  WIDTH = 800

  attr_reader :player

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Space Invaders"

    @background_image = Gosu::Image.new("media/space.png", tileable: true)
    @player = Player.new(x: 320, y: 470)
    @lasers = []
    @aliens = [Alien::SpaceShip.new]
  end

  def update
    if arrow_left?
      player.move_left
    end

    if arrow_right?
      player.move_right
    end

    if lasers?
      @lasers.each {|laser| laser.go }
    end

    @lasers = @lasers.reject {|laser| outside_viewable_window?(laser.y) }
    @aliens = remove_hit_aliens(@aliens, @lasers)

    player.move
    @aliens.each {|alien| alien.go }
  end

  def draw
    @background_image.draw(0, 0, ZOrder::BACKGROUND)
    @aliens.each {|alien| alien.draw }

    if lasers?
      @lasers.each {|laser| laser.draw }
    end

    player.draw
    # @font.draw("Total Score: #{ 0 }", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
  end

  private

  def remove_hit_aliens(aliens, lasers)
    aliens.reject do |alien|
      alien_hit_by_lasers?(alien, lasers)
    end
  end

  def alien_hit_by_lasers?(alien, lasers)
    lasers.any? do |laser|
      alien.hit_by?(laser)
    end
  end

  def outside_viewable_window?(y)
    y <= 20
  end

  def lasers?
    @lasers.length > 0
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
        @lasers << Laser.new(
          x: player.x,
          y: player.y,
          angle: player.angle,
          vel_x: player.vel_x,
          vel_y: player.vel_y
        )
      else
        super
    end
  end
end

SpaceInvaders.new.show