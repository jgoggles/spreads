class TestController < ApplicationController
  def lines
    @games = Game.with_spreads(nil, true)
  end

end
