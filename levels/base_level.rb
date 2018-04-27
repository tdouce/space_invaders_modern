module Levels
  class BaseLevel
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
      raise "Must implement"
    end

    def repopulation_threshold
      raise "Must implement"
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
      raise "Must implement"
    end

    def background_image
      @background_image ||= Gosu::Image.new("media/space.png", tileable: true)
    end

    def player_fortifications
      raise "Must implement"
    end

    def initialize_aliens
      raise "Must Implement"
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

    def repopulate_aliens?
      @aliens.length <= repopulation_threshold
    end
  end
end


