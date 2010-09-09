class Pick < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :pick_set

end
