class Standing < ActiveRecord::Base
  belongs_to :user
  belongs_to :week
  
  def self.generate_standing(pick_sets)
    pick_sets.each do |ps|
      wins = 0
      losses = 0
      pushes = 0
      ou_wins = 0
      ou_losses = 0
      ou_pushes = 0
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
        p.generate_over_under_result
        case p.over_under_result
        when 1
          ou_wins += 1
        when -1
          ou_losses += 1
        when 0
          ou_pushes +=1
        end
      end
      points = wins - losses
      ou_points = ou_wins - ou_losses
      if !Standing.where("user_id = #{ps.user_id}").where("week_id = #{ps.week_id}").exists?
        Standing.create!(:user_id => ps.user_id, :week_id => ps.week_id, :wins => wins, :losses => losses, :pushes => pushes, :points => points, :over_under_points => ou_points)
      else
        standing = Standing.where("user_id = #{ps.user_id}").where("week_id = #{ps.week_id}").first
        standing.update_attributes(:user_id => ps.user_id, :week_id => ps.week_id, :wins => wins, :losses => losses, :pushes => pushes, :points => points, :over_under_points => ou_points)
        puts "standing exists"
      end
    end
  end

  def self.for_season(users)
    season_standings = []
    users.each do |u|
      record = {}  
      record['player'] = u
      wins, losses, pushes, points, ou_points = 0, 0, 0, 0, 0
      u.standings.each do |s|
        wins += s.wins
        losses += s.losses
        pushes += s.pushes
        points += s.points 
        unless s.over_under_points.nil?
          ou_points += s.over_under_points
        end
      end
      record['wins'] = wins
      record['losses'] = losses
      record['pushes'] = pushes
      record['points'] = points
      record['ou_points'] = ou_points
      
      if Week.current.first.id > 1
        last_week = u.standings.where("week_id = #{Week.previous.id}")
        if !last_week.empty?
          record['last_week'] = "#{last_week[0].wins}-#{last_week[0].losses}-#{last_week[0].pushes}"
        else
          record['last_week'] = "-"
        end
      else
        record['last_week'] = "-"
      end
      season_standings.push(record)
    end
    return season_standings
  end
end
