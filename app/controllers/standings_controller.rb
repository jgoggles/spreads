class StandingsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @standings = Standing.for_season(User.all).sort_by {|i| -i['points']}
    @playoff_standings = Standing.for_season(User.all, start_week_id=17, end_week_id=24).sort_by {|i| -i['points']}
    @pick_sets = current_user.pick_sets.where("week_id > 17").sort_by {|p| p.week_id}
  end
end
