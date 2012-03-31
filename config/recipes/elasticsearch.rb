namespace :elasticsearch do
  desc "Install the latest relase of elasticsearch"
  task :install, roles: :app do
    run "#{sudo} pacman -Sq --noconfirm jre7-openjdk"
    run "curl -L -O https://aur.archlinux.org/packages/el/elasticsearch/elasticsearch.tar.gz"
    run "tar -xf elasticsearch.tar.gz"
    run "cd elasticsearch && makepkg -c"
    fname = capture "cd elasticsearch && ls *.xz"
    run "cd elasticsearch && #{sudo} pacman -U --noconfirm #{fname}"
    run "rm elasticsearch.tar.gz && rm -rf elasticsearch"
    add_service "elasticsearch"
    start
    #puts "\n\n\n\n\n ELASTIC SEARCH MUST BE INSTALLED MANUALLY !!!!!\n\n\n\n\n"
  end

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command, roles: :web do
      run "#{sudo} rc.d #{command} elasticsearch"
    end
  end

  after "deploy:install", "elasticsearch:install"
end

