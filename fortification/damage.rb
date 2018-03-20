module Fortification
  class Damage
    attr_reader :alien_lasers

    def initialize(alien_lasers:)
      @alien_lasers = alien_lasers
    end
  end
end