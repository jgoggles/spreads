require 'test_helper'

class GameTest < ActiveSupport::TestCase
  fixtures :games

  test "game has scores" do
    game = games(:one)
    assert game.has_scores
  end

end
