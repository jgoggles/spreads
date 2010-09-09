class PickSet < ActiveRecord::Base
  has_many :picks, :dependent => :destroy
  belongs_to :user
  belongs_to :week

  accepts_nested_attributes_for :picks, :reject_if => lambda { |a| a[:is_home].blank? || a[:spread].blank? }

  validate :number_of_picks

  def number_of_picks
    errors.add_to_base "You cannot have more than 3 picks in a week" if self.picks.size > 3
  end
end
