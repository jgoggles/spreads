class PickSet < ActiveRecord::Base
  has_many :picks
  belongs_to :user

  accepts_nested_attributes_for :picks, :reject_if => lambda { |a| a[:team].blank? || a[:spread].blank? }
end
