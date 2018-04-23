require_relative 'level_one'
require_relative 'level_two'

module Levels
  class World
    def initialize
      @idx = 0
    end

    def current_level
      levels[@idx].new
    end

    def transition_to_next_level
      levels[@idx += 1].new
    end

    def end_of_game?
      levels[@idx].nil?
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