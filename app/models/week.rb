class Week < ActiveRecord::Base
  has_many :pick_sets
  has_many :games

  scope :current, lambda {where("start_date <= ?", Time.now).where(["end_date >= ?", Time.now]).limit(1)}

  def self.previous
    if current.first.id > 1
      week = find(current.first.id - 1)
    end
  end
end
