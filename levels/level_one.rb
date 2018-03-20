require_relative '../alien/space_ship'
require_relative '../fortification/quadralateral'
require_relative '../fortification/damage'
require 'set'

module Levels
  class Fortifications
    def initialize
      @fortifcations = [
        Fortification::Quadralateral.new(top_left_x: 50, top_left_y: 385, width: 20),
        Fortification::Quadralateral.new(top_left_x: 300, top_left_y: 385, width: 20),
        Fortification::Quadralateral.new(top_left_x: 550, top_left_y: 385, width: 20),
      ]
    end

    def draw
      @fortifcations.each {|f| f.draw }
    end

    def assess_damage(player, aliens)
      @fortifcations.map do |f|
        f.assess_laser_damages(player, aliens)
      end
    end
  end

  class LevelOne
    attr_accessor :kill_count

    def initialize
      @kill_count = 0
    end

    def name
      "Level One"
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

    def repopulate_aliens?(aliens)
      aliens.length <= repopulation_threshold
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

    def player_fortifications
      Fortifications.new
    end
  end
end
