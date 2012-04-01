require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/postgresql"
load "config/recipes/elasticsearch"
load "config/recipes/nodejs"
load "config/recipes/imagemagick"
load "config/recipes/rbenv"
load "config/recipes/rubybuild"
load "config/recipes/ruby"
load "config/recipes/bundler"
load "config/recipes/unicorn"
load "config/recipes/check"
load "config/recipes/uploads"

server "178.79.182.149", :web, :app, :db, primary: true

set :application, "icip"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :default_environment, 'PATH' => "$PATH:$HOME/.rbenv/bin:$HOME/.rbenv/shims"

set :scm, "git"
set :repository, "git@github.com:lmbacelar/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

