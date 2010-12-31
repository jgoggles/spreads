class ApplicationController < ActionController::Base
  protect_from_forgery


  def restrict_to_admin
    if user_signed_in?
      unless current_user.admin?
        redirect_to '/', :status => 401
      end
    end
  end
end
