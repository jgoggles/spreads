require 'fastercsv'

Game.delete_all
FasterCSV.foreach("public/2010-nfl-schedule.csv") do |row|
  Game.create!(:week => row[0], :date => "#{row[1]} #{row[2]}".to_time, :away => row[3], :home => row[4] )
end
