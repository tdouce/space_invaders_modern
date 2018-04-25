require_relative '../alien/space_ship'
require_relative '../fortification/quadralateral'
require_relative '../fortification/damage'
require_relative 'base_level'
require_relative '../fortification/base_fortifications'
require 'set'

module Levels
  class Fortifications < Fortification::BaseFortifications ;end

  class LevelOne < Levels::BaseLevel
    def name
      "Level One"
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
  end
end
