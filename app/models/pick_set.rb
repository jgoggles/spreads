class PickSet < ActiveRecord::Base
  has_many :picks, :dependent => :destroy
  belongs_to :user
  belongs_to :week

  accepts_nested_attributes_for :picks, :reject_if => lambda { |a| a[:is_home].blank? || a[:spread].blank? }

  validate :number_of_picks

  def number_of_picks
    errors.add_to_base "You cannot have more than 3 picks in a week" if self.picks.size > 3
  end

  def check_for_non_picks
    if Week.find(self.week_id).end_date < Week.current.first.start_date
      if self.picks.size < 3
        losses = 3 - self.picks.size
        losses.times {Pick.create!(:spread => 0, :result => -1, :game_id => 0, :pick_set_id => self.id)}
      end
    end
  end

  def self.all_picks_in(week=Week.current.first)
    pick_sets = find_all_by_week_id(week.id)
    pick_total = 0
    pick_sets.each {|ps| pick_total += ps.picks.size}
    if pick_total == 27 
      return true
    else
      return false
    end
  end
end
