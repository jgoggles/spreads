class TestController < ApplicationController
  def lines
    @games = Game.with_spreads(nil)
  end

end
