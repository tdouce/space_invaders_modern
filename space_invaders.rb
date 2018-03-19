require 'gosu'
require_relative 'space_ship'
require_relative 'zorder'

include Gosu
include ZOrder

class SpaceInvaders < Gosu::Window
  HEIGHT = 640
  WIDTH = 440

  attr_reader :star_anim

  def initialize
    super(HEIGHT, WIDTH)
    self.caption = "Space Invaders"

    @background_image = Gosu::Image.new("media/space.png", tileable: true)
    @space_ship = SpaceShip.new
    @space_ship.move_to(320, 240)
  end

  def update
    if Gosu.button_down?(Gosu::KB_LEFT) || Gosu::button_down?(Gosu::GP_LEFT)
      @space_ship.turn_left
    end

    if Gosu.button_down?(Gosu::KB_RIGHT) || Gosu::button_down?(Gosu::GP_RIGHT)
      @space_ship.turn_right
    end

    @space_ship.move
  end

  def draw
    @background_image.draw(0, 0, ZOrder::BACKGROUND)
    @space_ship.draw
    @font.draw("Total Score: #{ 0 }", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
  end

  def button_down(id)
    case id
      when Gosu::KB_ESCAPE
        close
      when Gosu::KB_SPACE
        puts "BOOM"*80
      else
        super
    end
  end
end

SpaceInvaders.new.show