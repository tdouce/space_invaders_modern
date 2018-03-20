require_relative '../alien/space_ship'

module Levels
  class LevelOne
    attr_accessor :kill_count

    def initialize
      @kill_count = 0
    end

    def id
      1
    end

    def repopulation_threshold
      2
    end

    def inc_kill_count
      @kill_count += 1
    end

    def won?
      @kill_count == kills_to_win
    end

    def kills_to_win
      15
    end

    def aliens
      1.upto(rand(6)).map do |_|
        Alien::SpaceShip.new(x: 0, y: rand(40..200), angle: rand(-20..20))
      end
    end

    def background_image
      Gosu::Image.new("media/space.png", tileable: true)
    end
  end
end
