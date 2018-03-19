require_relative '../alien/alien_laser'
require 'gosu'

include ZOrder

module Alien
  attr_reader :x, :y, :angle, :vel_x, :vel_y

  class SpaceShip
    def initialize(x: 50, y: 50, angle: 5, vel_x: 0, vel_y: 0)
      @image = Gosu::Image.new("media/alien_spaceship_1.png")
      @x = x
      @y = y
      @angle = angle
      @vel_x = vel_x
      @vel_y = vel_y
      @shots_fired = 0
      @shot_second = 0
    end

    # QUESTION: Why does attr_reader not make this available as a method?
    def x
      @x
    end

    # QUESTION: Why does attr_reader not make this available as a method?
    def y
      @y
    end

    def draw
      @image.draw_rot(@x, @y, ZOrder::PLAYER, @angle + 10, 0.5, 0.5, 0.1, 0.1)
    end

    def go
      move
      accelerate
    end

    def hit_by?(laser)
      collectable?(@x, @y, laser.x, laser.y)
    end

    def shoot_laser
      Alien::Laser.new(
        x: @x,
        y: @y,
      )
    end

    def time_to_shoot?(seconds)
      second = seconds.round

      if (@shot_second != second)
        @shot_second = second
      else
        false
      end
    end

    private

    # TODO: Move to module 'Hittable'?
    def collectable?(x_threshold, y_threshold, star_x, star_y)
      Gosu.distance(x_threshold, y_threshold, star_x, star_y) < 35
    end

    def accelerate
      @vel_x += Gosu.offset_x(@angle, 0.9)

      # NOTE: This is really good for harder levels!
      # @vel_y += Gosu.offset_y(@angle, 0.9)
    end

    def move
      @x += @vel_x
      @y += @vel_y
      @x %= 640
      @y %= 480

      @vel_x *= 0.95
      @vel_y *= 0.75
    end
  end
end
