require_relative '../alien/space_ship'
require_relative '../fortification/quadralateral'
require_relative '../fortification/damage'
require 'set'

module Levels
  class Fortifications
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

  class LevelTwo
    attr_accessor :kill_count, :aliens

    def initialize
      @kill_count = 0
      @aliens = initialize_aliens
      players
    end

    def players
      @player_one ||= Player.new(x: 420, y: 470)
      @players = if two_players?
                   [
                     @player_one,
                     @player_two ||= Player.new(x: @player_one.x + 50, y: @player_one.y)
                   ]
                 else
                   [@player_one]
                 end
    end

    def player_health
      if @player_two
        @player_one.health - (Player::INITIAL_HEALTH - @player_two.health)
      else
        @player_one.health
      end
    end

    def score
      players.reduce(0) do |memo, p|
        memo += p.tally_score(@aliens)
      end
    end

    def name
      "Level Two"
    end

    def repopulation_threshold
      2
    end

    def inc_kill_count
      @kill_count += 1
    end

    def over?
      won? || lost?
    end

    def lost?
      player_health <= 0
    end

    def won?
      @kill_count == kills_to_win && player_health >= 0
    end

    def repopulate_aliens
      if repopulate_aliens?
        @aliens = @aliens + initialize_aliens
      end
    end

    def kills_to_win
      2
    end

    def background_image
      @background_image ||= Gosu::Image.new("media/space.png", tileable: true)
    end

    def player_fortifications
      Fortifications.new
    end

    private

    def two_players?
      @kill_count >= 15 && @kill_count <= 30
    end

    def initialize_aliens
      1.upto(rand(8)).map do |_|
        Alien::SpaceShip.new(
          x: 0,
          y: rand(40..200), angle: rand(-20..20)
        )
      end
    end

    def repopulate_aliens?
      @aliens.length <= repopulation_threshold
    end
  end
end
