class Pick < ActiveRecord::Base
  
  # Validations
  validates :spread, :game_id, :presence => true
  validates_inclusion_of :is_home, :in => [true, false]
  
  belongs_to :user
  belongs_to :game
  belongs_to :pick_set
  
  attr_readonly :spread, :game_id, :pick_set_id, :is_home

  validate :pick_time

  def pick_time
    unless self.game_id.nil?
      errors.add(:base, "Game has already started. Please pick a different game.") if Time.now > Game.find(self.game_id).date
    end
  end

  def team
    game = Game.find(self.game_id)
    if self.is_home? 
      game.home
    else
      game.away
    end
  end

  def generate_result 
    unless self.game_id == 0
      game = Game.find(self.game_id)
      if game.has_scores && Time.now > game.date
        if self.is_home?
          create_result((game.home_score + spread), game.away_score)
        else
          create_result((game.away_score + spread), game.home_score)
        end
      end
    end
  end

  def create_result(pick_score, non_pick_score)
    if pick_score > non_pick_score
      result = 1
    elsif pick_score < non_pick_score
      result = -1
    elsif pick_score == non_pick_score
      result = 0
    end
    self.update_attributes(:result => result)
  end
end
