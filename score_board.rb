class ScoreBoard
  def initialize
    @font = Gosu::Font.new(20)
  end

  def draw(world:)
    @font.draw(world.level.name, 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    @font.draw(world.score, 10, 30, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)

    space_ship = Gosu::Image.new("media/space_ship.bmp")
    lives_init_x = 10
    1.upto(world.level.player_health).each do |_|
      puts
      space_ship.draw_rot(lives_init_x, 55, 1, 0, 0, 0, 0.5, 0.5)
      lives_init_x += 25
    end
  end
end