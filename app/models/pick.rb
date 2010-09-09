class Pick < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :pick_set

  def team
    game = Game.find(self.game_id)
    if self.is_home? 
      team_name = game.home
    else
      team_name = game.away
    end
  end

  def generate_result
    game = Game.find(self.game_id)
    if self.is_home?
      get_result((game.home_score + spread), game.away_score)
    else
      get_result((game.away_score + spread), game.home_score)
    end
  end

  def get_result(pick_score, non_pick_score)
    if pick_score > non_pick_score
      result = 3
    elsif pick_score < non_pick_score
      result = 0
    elsif pick_score == non_pick_score
      result = 1
    end
  end
end
