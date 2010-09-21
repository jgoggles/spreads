class WeeksController < ApplicationController
  before_filter :authenticate_user!

  def index
    @week = Week.previous
    @users = User.all
  end

  def show
    @week = Week.find(params[:id])
  end
end
