require 'gosu'
include Gosu

class Player
  attr_reader :angle, :x, :y, :vel_x, :vel_y, :health, :score
  attr_accessor :lasers

  def initialize(x:, y:)
    @image = Gosu::Image.new("media/space_ship.bmp")
    @beep = Gosu::Sample.new("media/beep.wav")
    @x = x
    @y = y
    @vel_x = 0
    @vel_y = 0
    @angle = 0.0
    @health = 10
    @hit_second = 0
    @score = 0
    @lasers = []
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

  def shoot_laser
    @lasers << Laser.new(x: @x, y: @y)
  end

  def dead?
    @health <= 0
  end

  def hit_alien?(alien)
    @lasers.any? {|laser| collectable?(alien.x, alien.y, laser.x, laser.y) }
  end

  def assess_damage(lasers, seconds)
    second = seconds.round

    if valid_hit?(second, lasers)
        @hit_second = second
        @health -= 1
    else
      false
    end
  end

  def valid_hit?(second, lasers)
    (@hit_second != second) && hit_by_laser?(lasers)
  end

  def tally_score(aliens)
    @score = lasers.reduce(@score) do |memo, laser|
      points_per_alien = aliens.reduce(0) do |laser_memo, alien|
        if collectable?(alien.x, alien.y, laser.x, laser.y)
          laser_memo += alien.points_worth
        end

        laser_memo
      end

      points_per_alien + memo
    end
  end

  def hit_by_laser?(lasers)
    lasers.any? {|laser| collectable?(@x, @y, laser.x, laser.y)}
  end

  # TODO: Move this to a module
  def collectable?(x_threshold, y_threshold, star_x, star_y)
    Gosu.distance(x_threshold, y_threshold, star_x, star_y) < 35
  end
end