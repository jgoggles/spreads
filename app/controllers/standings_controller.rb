class StandingsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @standings = Standing.for_season(User.all).sort_by {|i| -i['points']}
    @playoff_standings = Standing.for_season(User.all, start_week_id=18, end_week_id=22).sort_by {|i| [-i['points'], -i['over_under_points']]}
    @pick_sets = current_user.pick_sets.where("week_id > 17").sort_by {|p| p.week_id}
  end
end
