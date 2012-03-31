namespace :rbenv do
  desc "Install rbenv, Ruby, and the Bundler gem"
  task :install, roles: :app do
    run "#{sudo} pacman -Sq --noconfirm curl git"
    run "git clone git://github.com/sstephenson/rbenv.git ~/.rbenv"
    run "echo 'export PATH=\"$HOME/.rbenv/bin:$PATH\"' >> ~/.bash_profile"
    run "echo 'eval \"$(rbenv init -)\"' >> ~/.bash_profile"
  end

  after "deploy:install", "rbenv:install"
end
