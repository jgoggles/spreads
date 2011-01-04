class User < ActiveRecord::Base
  has_many :picks
  has_many :pick_sets
  has_many :standings

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  def has_picks_for_this_week
    week = Week.current.first
    week_pick_set = self.pick_sets.where("week_id = #{week.id}")
    if !week_pick_set.empty?
      if week_pick_set[0].picks.count > 0
        return true
      else 
        return false
      end
    else
      return false
    end
  end
  
  def check_for_zero_picks(week_id=Week.previous.id)
    if pick_sets.where("week_id = #{week_id}").empty?
      pick_set = PickSet.create!(:user_id => self.id, :week_id => week_id)
#      3.times {Pick.create!(:spread => 0, :result => -1, :game_id => 0, :pick_set_id => pick_set.id)}
      games = Game.find_all_by_week_id(week_id).size
      games.times {Pick.create!(:spread => 0, :result => -1, :game_id => 0, :pick_set_id => pick_set.id, :over_under => 0, :over_under_result => -1)}
    else
      pick_sets.where("week_id = #{week_id}").each do |ps|
        ps.check_for_non_picks
      end
    end
  end
  
end
