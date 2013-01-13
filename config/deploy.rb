require "rvm/capistrano"
require "bundler/capistrano"

server "54.235.220.246", :web, :app, :db, primary: true

set :rvm_ruby_string, "1.9.3@bootstrap"
set :application, "bootstrap_data"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:recklessrahul/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    # put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    # run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end

  namespace :mongoid do
    desc "Copy mongoid config"
    task :copy do
      upload "config/mongoid/#{rails_env}.yml", "#{shared_path}/mongoid.yml", :via => :scp
    end

    desc "Link the mongoid config in the release_path"
    task :symlink do
      run "test -f #{release_path}/config/mongoid.yml || ln -s #{shared_path}/mongoid.yml #{release_path}/config/mongoid.yml"
    end

    desc "Create MongoDB indexes"
    task :index do
      run "cd #{current_path} && #{bundle_cmd} exec rake db:mongoid:create_indexes", :once => true
    end
  end
   
  after "deploy:update_code", "mongoid:copy"
  after "deploy:update_code", "mongoid:symlink"
  after "deploy:update", "mongoid:index"
  before "deploy", "deploy:check_revision"
end
