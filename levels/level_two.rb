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
  end
end
