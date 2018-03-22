require 'gosu'
require_relative 'player'
require_relative 'laser'
require_relative 'zorder'
require_relative 'alien/space_ship'
require_relative 'levels/level_one'

include Gosu
include ZOrder

class SpaceInvaders < Gosu::Window
  HEIGHT = 500
  WIDTH = 800

  attr_reader :player

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Space Invaders"

    @level = Levels::LevelOne.new
    @background_image = @level.background_image
    @player = Player.new(x: 320, y: 470)
    @aliens = @level.aliens
    @time_milli = 0
    @font = Gosu::Font.new(20)
    @fortifications = @level.player_fortifications
  end

  def update
    if arrow_left?
      player.move_left
    end

    if arrow_right?
      player.move_right
    end

    player.move

    @player.lasers.each {|laser| laser.go }
    @aliens.each {|alien| alien.lasers.each {|laser| laser.go }}
    @aliens.each {|alien| alien.go }

    @time_milli += update_interval
  end

  def draw
    @background_image.draw(0, 0, ZOrder::BACKGROUND)
    @aliens.each {|alien| alien.draw }
    player.lasers.each {|laser| laser.draw }
    @aliens.each {|alien| alien.lasers.each {|laser| laser.draw }}
    @fortifications.draw
    player.draw

    @player.lasers = player.lasers.select {|laser| inside_viewable_window?(laser.y) }
    @aliens.each do |alien|
      alien.lasers = alien.lasers.select {|laser| inside_viewable_window?(laser.y) }
    end

    @fortifications.assess_damage(player, @aliens)

    unless @level.won?
      @aliens.each {|alien| alien.shoot_laser(calc_seconds)}
    end

    @font.draw("Health: #{ player.health }", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    @font.draw("Points: #{ player.tally_score(@aliens) }", 10, 35, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)

    unless @level.won?
      @aliens = @aliens.reject do |alien|
        if player.hit_alien?(alien)
          @level.inc_kill_count
          true
        else
          false
        end
      end

      if @level.repopulate_aliens?(@aliens)
        @level.aliens.each do |alien|
          @aliens << alien
        end
      end
    end

    if player.dead?
      @font.draw("GAME OVER", 315, 225, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    else
      @player.assess_damage(@aliens.each {|alien| alien.lasers}, calc_seconds)
    end

    if @level.won?
      @font.draw("#{ @level.name} Complete!", 315, 225, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
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

  def inside_viewable_window?(y)
    y >= 40 && y <= 470
  end

  #TODO: move to a control module
  def arrow_right?
    Gosu.button_down?(Gosu::KB_RIGHT) || Gosu::button_down?(Gosu::GP_RIGHT)
  end
  #TODO: move to a control module
  def arrow_left?
    Gosu.button_down?(Gosu::KB_LEFT) || Gosu::button_down?(Gosu::GP_LEFT)
  end

  def button_down(id)
    case id
      when Gosu::KB_ESCAPE
        close
      when Gosu::KB_SPACE
        unless player.dead?
          player.shoot_laser
        end
      else
        super
    end
  end
end

SpaceInvaders.new.show