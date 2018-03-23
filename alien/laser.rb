require_relative '../zorder'
include ZOrder

module Alien
  class Laser
    attr_reader :x, :y

    def initialize(x:, y:, angle: 0, vel_x: 0, vel_y: 0)
      @image = Gosu::Image.new("media/alien_laser.png")
      @x = x
      @y = y
      @angle = angle
      @vel_x = vel_x
      @vel_y = vel_y
    end

    def draw
      @image.draw_rot(@x - 3, @y + 30, ZOrder::BACKGROUND, @angle + 43, 0.5, 0.5, 0.04, 0.07)
    end

    def go
      move
      accelerate
    end

    private

    def accelerate
      @vel_x += Gosu.offset_x(@angle, 0.5)
      @vel_y -= Gosu.offset_y(@angle, 0.5)
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
end
