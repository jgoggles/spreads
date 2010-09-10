require 'fastercsv'

############
# all envs #
############

## Games
Game.connection.execute("TRUNCATE games")
FasterCSV.foreach("public/2010-nfl-schedule.csv") do |row|
  Game.create!(:week_id => row[0].to_i, :date => "#{row[1]} #{row[2]}".to_time + 4.hours, :away => row[3], :home => row[4] )
end

## Weeks
Week.connection.execute("TRUNCATE weeks")
t = "Sept 6, 2010".to_date
w = 0
17.times do 
  Week.create!(:name => w += 1, :start_date => t + 1.day, :end_date => t += 1.week)
end

###############
# development #
###############

if Rails.env == "development"
  ## Games
  games = Game.where('week_id = 18')
  games.each {|g| g.update_attributes(:home_score => rand(42), :away_score => rand(42))}

  ## Weeks
  Week.create!(:name => 'Test', :start_date => Time.now - 5.years, :end_date => Time.now - 5.years + 1.week)

  ## Users
  User.connection.execute("TRUNCATE users")
  i = 0
  4.times do 
    User.create!(:email => "test_guy#{i += 1}@test.com", :password => "password", :password_confirmation => "password")
  end

  ## PickSets
  PickSet.connection.execute("TRUNCATE pick_sets")
  users = User.all
  users.each do |u|
    PickSet.create!(:user_id => u.id, :week_id => Week.all.size)
  end

  # Picks
  Pick.connection.execute("TRUNCATE picks")
  users = User.all
  i = -7.0; set = []; 28.times {set.push(i += 0.5)};
  pick_set_id = 0
  users.each do |u|
    game_id = 0
    pick_set_id += 1
    3.times do
      Pick.create!(:spread => set[rand(set.size - 1)], :game_id => game_id +=1, :pick_set_id => pick_set_id, :is_home => rand(2))
    end
  end
end


