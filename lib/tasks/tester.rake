desc "HereI am testing rake"
task :show_me => :environment do
  Week.first.update_attributes(:updated_at => Time.now)
end
