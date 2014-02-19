# config valid only for Capistrano 3.1
lock '3.1.0'



set :application, 'capistrano'
set :repo_url, 'git@github.com:ivanacorovic/blog.git'
set :user, "deployer"
set :deploy_to, "/home/deployer/capistrano"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
set :scm, :git
set :ssh_options, {
  forward_agent: true
}
# Default value for :format is :pretty
#set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      # Your restart mechanism here, for example:
      execute "/etc/init.d/unicorn_#{:application} restart"
    end
  end


  task :start do
    on roles(:app) do
      # Here we can do anything such as:
      # within release_path do
      execute "/etc/init.d/unicorn_#{:application} start"
      # end
    end
  end

    task :stop do
    on roles(:app) do
      # Here we can do anything such as:
      # within release_path do
      execute "/etc/init.d/unicorn_#{:application} stop"
      # end
    end
  end

  set :linked_files, %W{#{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}}
  set :linked_files, %W{#{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}}
  # task :setup_config do
  #   on roles(:app) do
  #     sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
  #     sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
  #     execute "mkdir -p #{shared_path}/config"
  #     put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
  #     puts "Now edit the config files in #{shared_path}."
  #   end
  # end

  after :finishing, "deploy:cleanup"
end
