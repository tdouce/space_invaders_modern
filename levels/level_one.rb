require_relative '../alien/space_ship'

module Levels
  class LevelOne
    def id
      1
    end

    def aliens
      1.upto(3).map do |_|
        Alien::SpaceShip.new(x: rand(0..600), y: rand(40..200), angle: rand(10))
      end
    end
  end
end
