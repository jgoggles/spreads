class WeeksController < ApplicationController
  before_filter :authenticate_user!

  def index
    @week = Week.previous
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
