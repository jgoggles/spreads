class PickSet < ActiveRecord::Base
  has_many :picks, :dependent => :destroy
  belongs_to :user
  belongs_to :week

  # the :reject_if prevents every pick from being saved since only selected picks will have those attributes inside of a hidden field
  # seems a little hacky, should look into changing at some point
  accepts_nested_attributes_for :picks, :reject_if => lambda { |a| a[:is_home].blank? && a[:spread].blank? && a[:over_under].blank? && a[:is_over].blank? }

#  validate :number_of_picks

  def number_of_picks
    errors.add(:base, "You cannot have more than 3 picks in a week") if self.picks.size > 3
  end

  def check_for_non_picks
#    if Week.find(self.week_id).end_date < Week.current.first.start_date
      games = Game.find_all_by_week_id(self.week_id).size
#      if self.picks.size < 3
      if self.picks.size < games
        losses = games - self.picks.size
        losses.times {Pick.create!(:spread => 0, :result => -1, :game_id => 0, :pick_set_id => self.id, :over_under => 0, :over_under_result => -1)}
      end
#    end
  end

  def self.all_picks_in(week=Week.current.first)
    games = Game.find_all_by_week_id(week.id).size
    pick_sets = find_all_by_week_id(week.id)
    pick_total = 0
    pick_sets.each do |ps| 
      ps.picks.each do |p|
        pick_total += 1 if p.complete
      end
    end
    if pick_total == User.all.size * games 
      return true
    else
      return false
    end
  end
end
