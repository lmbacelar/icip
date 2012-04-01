namespace :imagemagick do
  desc "Install the latest relase of Imagemagick, and linpng"
  task :install, roles: :app do
    run "#{sudo} pacman -Sq --noconfirm --noprogressbar imagemagick libpng"
  end
  after "deploy:install", "imagemagick:install"
end
