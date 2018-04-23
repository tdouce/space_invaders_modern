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

  class LevelOne
    attr_accessor :kill_count, :aliens

    def initialize(initial_score: 0, init_player_x: 420, init_player_y: 470)
      @kill_count = 0
      @aliens = initialize_aliens
      @max_number_of_players = 2
      @init_player_x = init_player_x
      @init_player_y = init_player_y
      @players = initialize_players
      @initial_score = initial_score
    end

    def players
      @players.each_with_index.map do |p, idx|
        p.active = if two_players?
                     true
                   else
                     (idx == 0)
                   end
        p
      end
    end

    def player_health
      @players.reduce(Player::INITIAL_HEALTH) do |agg, p|
        agg -= (Player::INITIAL_HEALTH - p.health)
        agg
      end
    end

    def score
      players.reduce(@initial_score) do |memo, p|
        memo += p.tally_score(@aliens)
      end
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
      45
    end

    def background_image
      @background_image ||= Gosu::Image.new("media/space.png", tileable: true)
    end

    def player_fortifications
      Fortifications.new
    end

    private

    def initialize_players
      num_of_players = 1.upto(@max_number_of_players - 1).to_a
      @players = [
        Player.new(
          x: @init_player_x,
          y: @init_player_y,
          active: true
        )
      ]
      current_player_x = @init_player_x
      num_of_players.each do |_|
        current_player_x += 50
        @players << Player.new(x: current_player_x, y: @init_player_y)
      end

      @players
    end

    def two_players?
      @kill_count >= 2 && @kill_count <= 8
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
