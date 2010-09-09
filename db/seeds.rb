require 'fastercsv'
def truncate_db_table(table)
  config = ActiveRecord::Base.configurations[Rails.env]
  ActiveRecord::Base.establish_connection
  case config["adapter"]
  when "mysql"
    ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
  when "sqlite", "sqlite3"
    ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
    ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence where name='#{table}'")
    ActiveRecord::Base.connection.execute("VACUUM")
  end
end

############
# all envs #
############

## Games
truncate_db_table('games')
FasterCSV.foreach("public/2010-nfl-schedule.csv") do |row|
  Game.create!(:week_id => row[0].to_i, :date => "#{row[1]} #{row[2]}".to_time + 4.hours, :away => row[3], :home => row[4] )
end

## Weeks
truncate_db_table('weeks')
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
  games = Game.where('week_id = 999')
  games.each {|g| g.update_attributes(:home_score => rand(42), :away_score => rand(42))}

  ## Users
  User.create!(:email => "test_guy1@test.com", :password => "password", :password_confirmation => "password")
  User.create!(:email => "test_guy2@test.com", :password => "password", :password_confirmation => "password")
end


