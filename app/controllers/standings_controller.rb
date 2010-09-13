class StandingsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @weeks = Week.all  
    @standings = Standing.for_season(User.all).sort_by {|i| -i['points']}
  end
end
