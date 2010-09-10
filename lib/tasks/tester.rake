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
  
  pick_sets = PickSet.where("week_id = #{week_id}")
  pick_sets.each do |ps|
    ps.picks.each do |p|
      game = Game.find(p.game_id)
      if Time.now > game.date
        p.generate_standing
        puts "generated standing for #{game.away} at #{game.home}"
      end
    end
  end
end
