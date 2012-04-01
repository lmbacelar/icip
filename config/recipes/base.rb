def file_includes_text?(file, text)
  run("grep '#{text}' #{file} && echo OK") == 'OK'
end

def append_to_file(file, text)
  run("echo '#{text}' >> #{file}") unless file_includes_text?(file, text)
end

def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def add_service(service)
  # Add service to rc.conf (prevent duplicates)
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

namespace :deploy do
  desc "Install everything onto the server"
  task :install, roles: :app do
    puts "\nPRE_REQUISITES:\n\n"
    puts "\ta. '#{user}' user created\n"
    puts "\tb. '#{user}' with sudo access\n"
    puts "\tc. Updated system\n"
    puts "\n\tOn Arch do:\n"
    puts "\t1. Login via ssh on root user.\n"
    puts "\t2. > adduser deployer\n\t\t(primary group users, secondary group wheel, accept defaults and set password)\n"
    puts "\t3. > visudo\n\t\t(uncomment line '%wheel ALL=(ALL) ALL')\n"
    puts "\t4. > pacman -Syy\n\t\t(synchronize database)\n"
    puts "\t5. > pacman -Syu\n\t\t(update system)\n\t\tNOTE: you might need to run this twice if pacman needs upgrading.\n"
    puts "\n\n\n\t\t\tIMPORTANT !!!\n\n"
    puts "\tDo not forget to manually add daemons that require autostart to rc.conf DAEMONS section.\n\n\n"
    run "#{sudo} pacman -Sq --noconfirm --noprogressbar base-devel"
  end
end
