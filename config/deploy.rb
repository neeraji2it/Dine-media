#require 'bundler/capistrano'
#require "whenever/capistrano"
set :user, 'ubuntu'
set :domain, '54.235.249.250'
set :applicationdir, "/var/www/dinemedia.com/public_html"
set :use_sudo, false
ssh_options[:keys] = ["/home/annapurna/Downloads/dinemediakey.pem"]
set :scm, 'git'
set :repository,  "git@github.com:neeraji2it/Dine-media.git"
set :git_enable_submodules, 1 # if you have vendored rails
set :branch, 'master'
#set :scm_passphrase, "shareef"  # The deploy user's password
default_run_options[:pty] = true  # Must be set for the password prompt from git to work
#set :repository_cache, "git_cache"
set :git_shallow_clone, 1
set :scm_verbose, true

# roles (servers)
role :web, domain
role :app, domain
role :db,  domain, :primary => true

#after :deploy, "gems:install"
#after "gems:install", "deploy:migrate"
# deploy config

set :deploy_to, applicationdir
set :deploy_via, :remote_cache
# Passenger
namespace :deploy do
  task :start do
    run "/etc/init.d/apache2 start"
  end
  task :stop do
    run "/etc/init.d/apache2 stop"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    #    run "touch #{File.join(current_path,'tmp','restart.txt')}"
    #     run "touch #{deploy_to}/current/tmp/restart.txt"
    run "touch #{current_path}/tmp/restart.txt"
  end
  after "deploy:update_code", :symlink
  after "deploy:symlink", "deploy:update_crontab"
  after "deploy", "deploy:restart"

end
namespace :sphinx do
  desc "Stop the sphinx server"
  task :stop, :roles => [:app], :only => {:sphinx => true} do
    run "cd #{latest_release} && RAILS_ENV=production rake thinking_sphinx:stop"
  end

  desc "Reindex the sphinx server"
  task :index, :roles => [:app], :only => {:sphinx => true} do
    run "cd #{latest_release} && RAILS_ENV=production rake thinking_sphinx:index"
  end

  desc "Configure the sphinx server"
  task :configure, :roles => [:app], :only => {:sphinx => true} do
    run "cd #{latest_release} && RAILS_ENV=production rake thinking_sphinx:configure"
  end

  desc "Start the sphinx server"
  task :start, :roles => [:app], :only => {:sphinx => true} do
    run "cd #{latest_release} && RAILS_ENV=production rake thinking_sphinx:start"
  end

  desc "Restart the sphinx server"
  task :restart, :roles => [:app], :only => {:sphinx => true} do
    run "cd #{latest_release} && RAILS_ENV=production rake thinking_sphinx:running_start"
  end
end
after "deploy:symlink_configs", "new_sphinx:configure"
after "sphinx:configure", "sphinx:index"
after "sphinx:index", "sphinx:restart"
#after "deploy:symlink", "deploy:update_crontab"

#namespace :deploy do
#desc "Update the crontab file"
#task :update_crontab, :roles => :db do
#run "cd #{latest_release} && whenever --update-crontab #{application}"
#end
#end
desc "Link to the configuration"
task :symlink do
  run "ln -s #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
  #run "ln -s #{shared_path}/public/uploaded_files #{latest_release}/public/uploaded_files"

end

desc "Update the crontab file"
task :update_crontab, :roles => :db do
  run "cd #{latest_release} && whenever --update-crontab #{application}"
end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end





