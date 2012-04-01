namespace :bundler do
  desc "Bundler gem"
  task :install, roles: :app do
    run "gem install bundler -q --no-ri --no-rdoc"
    run "rbenv rehash"
  end

  after "deploy:install", "bundler:install"
end
