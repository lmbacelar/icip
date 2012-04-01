namespace :elasticsearch do
  desc "Install the latest relase of elasticsearch"
  task :install, roles: :app do
    run "#{sudo} pacman -Sq --noconfirm --noprogressbar jre7-openjdk"
    run "curl -s -L -O https://aur.archlinux.org/packages/el/elasticsearch/elasticsearch.tar.gz"
    run "tar -xf elasticsearch.tar.gz"
    run "cd elasticsearch && makepkg -c > /dev/null 2>&1"
    fname = capture "cd elasticsearch && ls *.xz"
    run "cd elasticsearch && #{sudo} pacman -U --noconfirm --noprogressbar #{fname}"
    run "rm elasticsearch.tar.gz && rm -rf elasticsearch"
    restart
    add_service "elasticsearch"
  end

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command, roles: :web do
      run "#{sudo} rc.d #{command} elasticsearch"
    end
  end

  after "deploy:install", "elasticsearch:install"
end

