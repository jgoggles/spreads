class Week < ActiveRecord::Base
  has_many :pick_sets
  has_many :games

  scope :current, lambda {where("start_date <= ?", Time.now).where(["end_date >= ?", Time.now]).limit(1)}
end
