require_relative 'quadralateral'

module Fortification
  class BaseFortifications
    def initialize
      @fortifcations = [
        Fortification::Quadralateral.new(top_left_x: 50,  top_left_y: 385, height: 1, width: 15, pixel: 8),
        Fortification::Quadralateral.new(top_left_x: 300, top_left_y: 385, height: 1, width: 15, pixel: 8),
        Fortification::Quadralateral.new(top_left_x: 550, top_left_y: 385, height: 1, width: 15, pixel: 8),
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
end