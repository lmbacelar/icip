def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def add_service(service)
  puts "\nWARNING: Add #{service} to /etc/rc.conf DAEMONS section to make service autostart.\n"
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

namespace :deploy do
  desc "Install everything onto the server"
  task :install, roles: :app do
    puts "\nPRE_REQUISITES:\n-#{user} user setup, with sudo access.\nOn Arch do:\ni"
    puts "\t1. Login via ssh on root user."
    puts "\t2. > adduser deployer\n\t\t(primary group users, secondary group wheel, accept defaults and set password)"
    puts "\t3. > visudo\n\t\t(uncomment line '%wheel ALL=(ALL) ALL')"
    puts "\t4. > pacman -Syy\n\t\t(synchronize database)"
    puts "\t5. > pacman -Syu\n\t\t(update system)"
    puts "\tAll Done..."
    #run "#{sudo} pacman -Syy"
    #run "#{sudo} pacman -Sq --noconfirm base-devel"
  end
end
