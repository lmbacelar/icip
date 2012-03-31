set :default_environment, 'PATH' => "$PATH:$HOME/.rbenv/bin:$HOME/.rbenv/shims"

namespace :bundler do
  desc "Bundler gem"
  task :install, roles: :app do
    run "gem install bundler --no-ri --no-rdoc"
    run "rbenv rehash"
  end

  after "deploy:install", "bundler:install"
end
