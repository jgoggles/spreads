class Game < ActiveRecord::Base
  attr_accessor :spread
  has_many :picks
end
