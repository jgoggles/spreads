class TestController < ApplicationController
  def lines
    @games = Game.with_spreads
  end

end
