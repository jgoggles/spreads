class User < ActiveRecord::Base
  has_many :picks
  has_many :pick_sets

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  def has_picks_for_this_week
    week = Week.current.first
    if !self.pick_sets.empty?
      if self.pick_sets.where("week_id = #{week.id}")[0].picks.count > 0
        return true
      else 
        return false
      end
    else
      return false
    end
  end
end
