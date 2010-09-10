class StandingsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @weeks = Week.all  
  end
end
