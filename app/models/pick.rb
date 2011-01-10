class Pick < ActiveRecord::Base
  
  # Validations
#  validates :spread, :game_id, :presence => true
#  validates_inclusion_of :is_home, :in => [true, false]
  
  before_create :clone_and_delete_duplicate_pick  

  belongs_to :user
  belongs_to :game
  belongs_to :pick_set
  
#  attr_readonly :spread, :over_under, :game_id, :pick_set_id, :is_home

#  validate :pick_time

#  def pick_time
#    unless self.game_id.nil?
#      errors.add(:base, "Game has already started. Please pick a different game.") if Time.now > Game.find(self.game_id).date
#    end
#  end

# this checks for picks with the same pick_set_id and game_id. if one is found it clones the appropriate attributes from 
# the existing record to the new record then deletes the existing record. basially it's a piecemeal update_attributes and is
# needed because the pick_set form only builds new records since its creating form elements from scraped data 
  def clone_and_delete_duplicate_pick
    pick_sets = PickSet.where("week_id = #{Week.current.first.id}").collect(&:picks)
    pick_sets.each do |ps|
      ps.each do |p|
        if p.game_id == self.game_id && p.pick_set_id == self.pick_set_id
          logger.info "*******************************"
          if self.over_under.nil? 
            self.attributes = {:over_under => p.over_under, :is_over => p.is_over}
          else
            self.attributes = {:spread => p.spread, :is_home => p.is_home}
          end
          Pick.delete(p.id)
        end
      end
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

  def generate_over_under_result 
    unless self.game_id == 0 || self.over_under.nil?
      game = Game.find(self.game_id)
      if game.has_scores && Time.now > game.date 
        over = self.over_under < game.home_score + game.away_score
        even = self.over_under == game.home_score + game.away_score
        if self.is_over? && over || !self.is_over? && !over
          result = 1
        elsif even
          result = 0
        else
          result = -1
        end
        self.update_attributes(:over_under_result => result)
      end
    end
  end

  def complete
    !self.spread.nil? && !self.over_under.nil?
  end
end
