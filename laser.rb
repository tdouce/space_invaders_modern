require_relative 'zorder'
include ZOrder

class Laser
  attr_reader :y

  def initialize(x:, y:, angle:, vel_x:, vel_y:)
    @image = Gosu::Image.new("media/laser.png")
    @x = x
    @y = y
    @angle = angle
    @vel_x = vel_x
    @vel_y = vel_y
  end

  def draw
    @image.draw_rot(@x + 3, @y - 30, ZOrder::PLAYER, @angle + 210, 0.5, 0.5, 0.05, 0.05)
  end

  def go
    move
    accelerate
  end

  private

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
end
