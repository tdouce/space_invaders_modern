require 'gosu'
require_relative 'player'
require_relative 'laser'
require_relative 'zorder'
require_relative 'alien/space_ship'

include Gosu
include ZOrder

class SpaceInvaders < Gosu::Window
  HEIGHT = 500
  WIDTH = 800

  attr_reader :player

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Space Invaders"

    @background_image = Gosu::Image.new("media/space.png", tileable: true)
    @player = Player.new(x: 320, y: 470)
    @player_lasers = []
    @alien_lasers = []
    @aliens = 1.upto(3).map do |_|
      Alien::SpaceShip.new(x: rand(0..600), y: rand(40..200), angle: rand(10))
    end
    @time_milli = 0
    @font = Gosu::Font.new(20)
  end

  def update
    if arrow_left?
      player.move_left
    end

    if arrow_right?
      player.move_right
    end

    player.move

    @player_lasers.each {|laser| laser.go }
    @alien_lasers.each {|laser| laser.go }
    @player_lasers = @player_lasers.reject {|laser| outside_viewable_window?(laser.y) }
    @alien_lasers = @alien_lasers.reject {|laser| outside_viewable_window?(laser.y) }
    @aliens = remove_hit_aliens(@aliens, @player_lasers)

    @aliens.each {|alien| alien.go }

    @aliens.each do |alien|
      if alien.time_to_shoot?(calc_seconds)
        @alien_lasers << alien.shoot_laser
      end
    end

    @player.assess_damage(@alien_lasers, calc_seconds)

    @time_milli += update_interval
  end

  def draw
    @background_image.draw(0, 0, ZOrder::BACKGROUND)
    @aliens.each {|alien| alien.draw }
    @player_lasers.each {|laser| laser.draw }
    @alien_lasers.each {|laser| laser.draw }

    player.draw

    @font.draw("Health: #{ @player.health }", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)

    if @player.dead?
      @font.draw("GAME OVER", 180, 80, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    end
  end

  private

  def calc_seconds
    if @time_milli > 1
      @time_milli / 1000
    else
      @time_milli
    end
  end

  def remove_hit_aliens(aliens, lasers)
    aliens.reject do |alien|
      alien_hit_by_lasers?(alien, lasers)
    end
  end

  def alien_hit_by_lasers?(alien, lasers)
    lasers.any? do |laser|
      alien.hit_by?(laser)
    end
  end

  def outside_viewable_window?(y)
    y <= 10
  end

  def arrow_right?
    Gosu.button_down?(Gosu::KB_RIGHT) || Gosu::button_down?(Gosu::GP_RIGHT)
  end

  def arrow_left?
    Gosu.button_down?(Gosu::KB_LEFT) || Gosu::button_down?(Gosu::GP_LEFT)
  end

  def button_down(id)
    case id
      when Gosu::KB_ESCAPE
        close
      when Gosu::KB_SPACE
        @player_lasers << player.shoot_laser
        # @aliens.each do |alien|
        #   @alien_lasers << alien.shoot_laser
        # end
      else
        super
    end
  end
end

SpaceInvaders.new.show