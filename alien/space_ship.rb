require_relative '../alien/alien_laser'
require 'gosu'

include ZOrder

module Alien
  attr_reader :x, :y, :angle, :vel_x, :vel_y

  class SpaceShip
    def initialize(x: 50, y: 50, angle: 5, vel_x: 5, vel_y: 0)
      @image = Gosu::Image.new("media/alien_spaceship_1.png")
      @x = x
      @y = y
      @angle = angle
      @vel_x = vel_x
      @vel_y = vel_y
      @shots_fired_for_second = 0
      @shot_second = 0
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
      rounded_seconds = seconds.round
      last_integer = rounded_seconds.to_s[-1].to_i

      if (rand(10) == last_integer) && (@shots_fired_for_second < max_shots_per_second)
        @shots_fired_for_second += 1
        true
      elsif @shot_second != rounded_seconds
        @shots_fired_for_second = 0
        @shot_second = rounded_seconds
      else
        false
      end
    end

    private

    def max_shots_per_second
      1
    end

    # TODO: Move to module 'Hittable'?
    def collectable?(x_threshold, y_threshold, star_x, star_y)
      Gosu.distance(x_threshold, y_threshold, star_x, star_y) < 35
    end

    def accelerate
      @vel_x += Gosu.offset_x(@angle, 0.9)
      # @vel_y += Gosu.offset_y(@angle, 0.9)
    end

    def move
      @x += @vel_x
      @y += @vel_y
      @x %= 640
      # @y %= 480

      @vel_x *= 0.95
      # @vel_y *= 0.75
    end
  end
end
