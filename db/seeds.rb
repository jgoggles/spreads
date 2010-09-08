require 'fastercsv'

Game.delete_all
FasterCSV.foreach("public/2010-nfl-schedule.csv") do |row|
  Game.create!(:week_id => row[0].to_i, :date => "#{row[1]} #{row[2]}".to_time, :away => row[3], :home => row[4] )
end

Week.delete_all
t = "Sept 6, 2010".to_date
w = 0
17.times do 
  Week.create!(:name => w += 1, :start_date => t + 1.day, :end_date => t += 1.week)
end
