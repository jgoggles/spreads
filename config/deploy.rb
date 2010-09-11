# #############################################################
# # Application
# #############################################################
  
 set :application, "spreads"
 set :deploy_to, "/var/www/#{application}"
  
# #############################################################
# # Settings
# #############################################################
  
 default_run_options[:pty] = true
 ssh_options[:forward_agent] = true
 set :use_sudo, true
 set :scm_verbose, true
  
# #############################################################
# # Servers
# #############################################################
  
 set :user, "jgoggles"
 set :domain, "174.143.150.128"
 server domain, :app, :web
 role :db, domain, :primary => true
 set :port, 1616
 set :runner, "jgoggles"

  
# #############################################################
# # Git
# #############################################################
  
 set :scm, :git
 set :branch, "master"
 set :scm_user, "jgoggles"
 set :scm_passphrase, "jerktown08"
 set :repository, "git@github.com:jgoggles/spreads.git"
 set :deploy_via, :remote_cache
 
# #############################################################
# # Deploy for Passenger
# #############################################################
  
 namespace :deploy do
   
   desc "Restarting mod_rails with restart.txt"
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "touch #{current_path}/tmp/restart.txt"
   end
   
   [:start, :stop].each do |t|
     desc "#{t} task is a no-op with mod_rails"
     task t, :roles => :app do ; end
   end
   
   desc "invoke the db migration"
   task :migrate, :roles => :app do
     run "cd #{current_path} && rake db:migrate RAILS_ENV=production "   
   end
   
   desc "clear cache"
   task :clear, :roles => :app do
     run "cd #{deploy_to} && rake tmp:assets:clear"
   end
   
   desc "stop backgroundrb"
   task :backgroundrb_stop, :roles => :app do
     run "cd #{deploy_to} && rake backgroundrb:stop"
   end
   
   desc "start backgroundrb"
   task :backgroundrb_start, :roles => :app do
     run "cd #{deploy_to} && rake backgroundrb:start"
   end
   
   desc "restart backgroundrb"
   task :backgroundrb_restart, :roles => :app do
     run "cd #{deploy_to} && rake backgroundrb:restart"
   end
   
 end
 
 after "deploy:update_code", :roles => [:web, :db, :app] do
   run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml" 
 end