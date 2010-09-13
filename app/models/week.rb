class Week < ActiveRecord::Base
  has_many :pick_sets
  has_many :games
  has_many :standings

  scope :current, lambda {where("start_date <= ?", Time.now).where(["end_date >= ?", Time.now]).limit(1)}

  def self.previous
    if current.first.id > 1
      week = find(current.first.id - 1)
    end
  end
  
  def home_vs_away
    home, away = 0.0, 0.0
    self.pick_sets.each do |ps|
      ps.picks.each do |p|
        if p.is_home
          home +=1
        elsif !p.is_home && !p.is_home.nil? 
          away +=1
        end
      end
    end
    return [home, away]
  end
  
  def most_action
    game_ids = []
    self.pick_sets.each do |ps|
      ps.picks.each do |p|
        game_ids.push(p.game_id)
      end
    end
    freq = game_ids.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    max = freq.values.max
    max_games = freq.select { |k, f| f == max }
    most_action = []
    max_games.each do |mg|
      game = {}
      game['game'] = Game.find(mg[0])
      game['freq'] = mg[1]
      most_action.push(game)
    end
    return most_action
  end

  def most_picked
    games = {}
    self.pick_sets.each do |ps|
      ps.picks.each do |p|
        p.is_home ? h = 1 : h = 0
        games["#{p.game_id}#{h}"] ||= 0
        games["#{p.game_id}#{h}"] += 1
      end
    end
    max = games.values.max
    max_games = games.select { |k, f| f == max }
    most_picked = []
    max_games.each do |mg|
      game = {}
      g = Game.find(mg[0].first)
      mg[0].last == '1' ? game['team'] = g.home : game['team'] = g.away
      game['freq'] = mg[1]
      most_picked.push(game)
    end
    return most_picked
  end
  
end
