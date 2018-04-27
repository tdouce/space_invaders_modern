require_relative '../alien/space_ship'
require_relative '../fortification/quadralateral'
require_relative '../fortification/damage'
require 'set'

module Levels
  class Fortifications < Fortification::BaseFortifications ;end

  class LevelTwo < Levels::BaseLevel
    def name
      "Level Two"
    end

    def repopulation_threshold
      2
    end

    def kills_to_win
      5
    end

    def player_fortifications
      @player_fortifications ||= Fortifications.new
    end

    def initialize_aliens
      1.upto(rand(10)).map do |_|
        Alien::SpaceShip.new(
          x: 0,
          y: rand(40..200), angle: rand(-20..20)
        )
      end
    end
  end
end
