require_relative 'level_one'
require_relative 'level_two'

module Levels
  class World
    attr_accessor :current_level

    def initialize
      @idx = 0
      @current_level = levels[@idx].new
    end

    def transition_to_next_level
      @current_level = levels[@idx += 1].new
    end

    def end_of_game?
      levels[@idx + 1].nil?
    end

    private

    def levels
      [
        Levels::LevelOne,
        Levels::LevelTwo,
      ]
    end
  end
end