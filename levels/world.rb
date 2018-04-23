require_relative 'level_one'
require_relative 'level_two'

module Levels
  class World
    attr_accessor :level
    attr_reader :score

    def initialize
      @idx = 0
      @level = levels[@idx].new
    end

    def transition_to_next_level
      @level = levels[@idx += 1].new

    def calculate_score
      @score = level.score
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