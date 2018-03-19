require 'gosu'
include Gosu

class Player
  attr_reader :angle, :x, :y, :vel_x, :vel_y

  def initialize(x:, y:)
    @image = Gosu::Image.new("media/space_ship.bmp")
    @beep = Gosu::Sample.new("media/beep.wav")
    @x = x
    @y = y
    @vel_x = 0
    @vel_y = 0
    @angle = 0.0
  end

  def move_left
    @x -= 4.5
  end

  def move_right
    @x += 4.5
  end

  def accelerate
    @vel_x += Gosu.offset_x(@angle, 0.5)
    @vel_y += Gosu.offset_y(@angle, 0.5)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 640
    @y %= 480

    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  # def collectable?(x_threshold, y_threshold, star_x, star_y)
  #   Gosu.distance(x_threshold, y_threshold, star_x, star_y) < 35
  # end
end