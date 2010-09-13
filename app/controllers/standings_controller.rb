class StandingsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @standings = Standing.for_season(User.all).sort_by {|i| -i['points']}
    @pick_sets = current_user.pick_sets.sort_by {|p| p.week_id}
  end
end
