class Standing < ActiveRecord::Base
  belongs_to :user
  belongs_to :week
  
  def self.generate_standing(pick_sets)
    pick_sets.each do |ps|
      wins = 0
      losses = 0
      pushes = 0
      ps.picks.each do |p|
        p.generate_result
        case p.result
        when 1
          wins += 1
        when -1
          losses += 1
        when 0
          pushes +=1
        end
      end
      points = wins - losses
      if !Standing.where("user_id = #{ps.user_id}").where("week_id = #{ps.week_id}").exists?
        Standing.create!(:user_id => ps.user_id, :week_id => ps.week_id, :wins => wins, :losses => losses, :pushes => pushes, :points => points)
      else
        standing = Standing.where("user_id = #{ps.user_id}").where("week_id = #{ps.week_id}").first
        standing.update_attributes(:user_id => ps.user_id, :week_id => ps.week_id, :wins => wins, :losses => losses, :pushes => pushes, :points => points)
        puts "standing exists"
      end
    end
  end

  def self.for_season(users)
    season_standings = []
    users.each do |u|
      record = {}  
      record['player'] = u
      wins, losses, pushes, points = 0, 0, 0, 0
      u.standings.each do |s|
        wins += s.wins
        losses += s.losses
        pushes += s.pushes
        points += s.points 
      end
      record['wins'] = wins
      record['losses'] = losses
      record['pushes'] = pushes
      record['points'] = points
      
      if Week.current.first.id > 1
        last_week = u.standings.where("week_id = #{Week.previous}")
        record['last_week'] = "#{last_week[0].wins}-#{last_week[0].losses}-#{last_week[0].pushes}"
      else
        record['last_week'] = "-"
      end
      season_standings.push(record)
    end
    return season_standings
  end
end
