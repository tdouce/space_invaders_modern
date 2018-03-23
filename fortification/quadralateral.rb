require_relative '../fortification/damage'

module Fortification
  class LaserDamage
    def initialize(hit:)
      @hit = hit
    end

    def hit?
      @hit
    end
  end

  class Layer
    attr_reader :x, :y

    def initialize(x1:, y1:, x2:, y2:, x3:, y3:, x4:, y4:)
      @x1 = x1
      @y1 = y1
      @x2 = x2
      @y2 = y2
      @x3 = x3
      @y3 = y3
      @x4 = x4
      @y4 = y4
      @x = x1
      @y = y1
    end

    def draw
      color = Gosu::Color::BLACK.dup
      color.red = 0
      color.green = 255
      color.blue = 0

      draw_quad(
        @x1, @y1, color,
        @x2, @y2, color,
        @x3, @y3, color,
        @x4, @y4, color,
        ZOrder::PLAYER)
    end

    def assess_laser_damages(player:, aliens:)
      hit = false

      player.lasers = player.lasers.reject do |laser|
        if hit?(laser)
          hit = true
        else
          false
        end
      end

      aliens.each do |alien|
        alien.lasers = alien.lasers.reject do |laser|
          if hit?(laser)
            hit = true
          else
            false
          end
        end
      end

      LaserDamage.new(hit: hit)
    end

    private

    def hit?(laser)
      collectable?(@x, @y, laser.x, laser.y)
    end

    # TODO: Move this to a module
    def collectable?(x_threshold, y_threshold, star_x, star_y)
      Gosu.distance(x_threshold, y_threshold, star_x, star_y) < 10
    end
  end

  class Quadralateral
    def initialize(top_left_x:, top_left_y:, width: 10, height: 10, pixel: 5)
      @top_left_x = top_left_x
      @top_left_y = top_left_y
      @width = width
      @height = height
      @pixel = pixel
      @layers = initialize_layers
    end

    def draw
      @layers.each do |layer|
        layer.each do |sublayer|
          sublayer.draw
        end
      end
    end

    def assess_laser_damages(player, aliens)
      @layers = Set.new(
        assess_laser_damage(player, aliens)
      )
    end

    private

    # TODO: Refactor this
    def assess_laser_damage(player, aliens)
      new_layers = []
      @layers.each do |layer|
        sublayers = []
        layer.each do |sublayer|
          laser_damages = sublayer.assess_laser_damages(
            player: player,
            aliens: aliens
          )
          if !laser_damages.hit?
            sublayer.draw
            sublayers << sublayer
          end
        end

        new_layers << sublayers
      end

      new_layers
    end

    def initialize_layers
      diff = @pixel
      pin_x = @top_left_x
      pin_y = pin_x + diff
      x1 = pin_x
      y1 = @top_left_y
      x2 = x1 + diff
      y2 = y1
      x3 = x1
      y3 = y1 + diff
      x4 = x1 + diff
      y4 = y1 + diff

      1.upto(@height).map do |_|
        layers = 1.upto(@width).map do |n|
          x1, y1 = [x1 + diff, y1]
          x2, y2 = [x2 + diff, y2]
          x3, y3 = [x3 + diff, y3]
          x4, y4 = [x4 + diff, y4]

          color = Gosu::Color::BLACK.dup
          color.red = 0
          color.green = (255 - (n * 8))
          color.blue = 0

          Layer.new(x1: x1, y1: y1, x2: x2, y2: y2, x3: x3, y3: y3, x4: x4, y4: y4)
        end

        x1 = pin_x
        y1 = y1 + diff
        x2 = pin_y
        y2 = y2 + diff
        x3 = pin_x
        y3 = y3 + diff
        x4 = pin_y
        y4 = y4 + diff

        Set.new(layers)
      end
    end
  end
end