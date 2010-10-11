class WeeksController < ApplicationController
  before_filter :authenticate_user!, :check_pick_total

  def check_pick_total
    if PickSet.all_picks_in
      @week_list = Week.current.first
    else
      @week_list = Week.previous
    end
  end

  def index
    @week = @week_list
    @users = User.all
  end

  def show
    if params[:id].to_i >= Week.current.first.id
      redirect_to weeks_url
    else
      @week = Week.find(params[:id])
      @users = User.all
    end
  end
end
