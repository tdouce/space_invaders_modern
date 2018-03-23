require 'gosu'

module Controllable
  def arrow_right?
    Gosu.button_down?(Gosu::KB_RIGHT) || Gosu::button_down?(Gosu::GP_RIGHT)
  end

  def arrow_left?
    Gosu.button_down?(Gosu::KB_LEFT) || Gosu::button_down?(Gosu::GP_LEFT)
  end
end