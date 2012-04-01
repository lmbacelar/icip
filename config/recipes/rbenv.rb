namespace :rbenv do
  desc "Install rbenv, Ruby, and the Bundler gem"
  task :install, roles: :app do
    run "#{sudo} pacman -Sq --noconfirm curl git"
    run "git clone git://github.com/sstephenson/rbenv.git ~/.rbenv"
    run "echo '# Add rbenv to $PATH and remove duplicate entries' >> ~/.profile"
    run "echo 'PATH=\"$HOME/.rbenv/bin:$PATH\"' >> ~/.profile"
    run "echo 'PATH=$(echo \"$PATH\" | awk -v RS=':' -v ORS=\":\" '!a[$1]++')' >> ~/.profile"
    run "echo 'PATH=\"${PATH%:}\"' >> ~/.profile"
    run "echo 'export PATH' >> ~/.profile"
    run "echo 'eval \"$(rbenv init -)\"' >> ~/.profile"
  end

  after "deploy:install", "rbenv:install"
end
