require 'gosu'
require_relative 'player'
require_relative 'zorder'

include Gosu
include ZOrder

class SpaceInvaders < Gosu::Window
  HEIGHT = 500
  WIDTH = 800

  attr_reader :star_anim

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Space Invaders"

    @background_image = Gosu::Image.new("media/space.png", tileable: true)
    @player = Player.new
    @player.move_to(320, 470)
  end

  def update
    if Gosu.button_down?(Gosu::KB_LEFT) || Gosu::button_down?(Gosu::GP_LEFT)
      @player.move_left
    end

    if Gosu.button_down?(Gosu::KB_RIGHT) || Gosu::button_down?(Gosu::GP_RIGHT)
      @player.move_right
    end

    @player.move
  end

  def draw
    @background_image.draw(0, 0, ZOrder::BACKGROUND)
    @player.draw
    # @font.draw("Total Score: #{ 0 }", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
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