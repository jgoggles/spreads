desc "Gets scores for this week"
task :get_scores => :environment do
  if Time.now.day == Week.current.first.start_date.day
    week = Week.previous
  else
    week = Week.current.first
  end

  puts "Getting scores for Week #{week.name}..."
  Game.get_scores(week)
  puts "Done"
end

desc "Generates results and standings for this week's picks"
task :generate_standings => :environment do
  if Time.now.day == Week.current.first.start_date.day
    week = Week.previous
  else
    week = Week.current.first
  end

  week_id = ENV['WEEK_ID'] || week.id
  
  pick_sets = Week.find(week_id).pick_sets
  Standing.generate_standing(pick_sets)
end

desc "Generates losses for non-picks"
task :scrub_non_picks => :environment do
  User.all.each {|u| u.check_for_zero_picks}
end
