namespace :nodejs do
  desc "Install the latest relase of Node.js"
  task :install, roles: :app do
    run "#{sudo} pacman -Sq --noconfirm nodejs"
  end
  after "deploy:install", "nodejs:install"
end
