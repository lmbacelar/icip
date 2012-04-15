set_default(:nginx_user, "root")
set_default(:nginx_workers, 2)
set_default(:nginx_connections, 1024)
set_default(:domain_name) { Capistrano::CLI.ui.ask "Domain name to use: " }
set_default(:ssl_key_passphrase) { Capistrano::CLI.password_prompt "Nginx HTTPS Key Passphrase: " }

namespace :nginx do
  desc "Install latest stable release of nginx"
  task :install, roles: :web do
    run "#{sudo} pacman -Sq --noconfirm nginx"
    run "#{sudo} mkdir -p /etc/nginx/sites-enabled"
    template "nginx.conf.erb", "/tmp/nginx_conf"
    run "#{sudo} mv /tmp/nginx_conf /etc/nginx/conf/nginx.conf"
    run "#{sudo} openssl genrsa -des3 -passout pass:#{ssl_key_passphrase} -out server.key 1024"
    run "#{sudo} openssl req -new -passin pass:#{ssl_key_passphrase} -key server.key -subj \"/C=PT/ST=Denial/L=Lisbon/O=Dis/CN=#{domain_name}\" -out server.csr"
    run "#{sudo} cp server.key server.key.org"
    run "#{sudo} openssl rsa -passin pass:#{ssl_key_passphrase} -in server.key.org -out server.key"
    run "#{sudo} openssl x509 -req -passin pass:#{ssl_key_passphrase} -days 365 -in server.csr -signkey server.key -out server.crt"
    run "#{sudo} mv server.crt /etc/nginx/conf"
    run "#{sudo} mv server.key /etc/nginx/conf"
    run "#{sudo} rm server.csr server.key.org"
    add_service "nginx"
  end
  after "deploy:install", "nginx:install"

  desc "Setup nginx configuration for this application"
  task :setup, roles: :web do
    template "nginx_unicorn.erb", "/tmp/nginx_unicorn"
    run "#{sudo} mv /tmp/nginx_unicorn /etc/nginx/sites-enabled/#{application}"
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
    restart
  end
  after "deploy:setup", "nginx:setup"

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command, roles: :web do
      run "#{sudo} rc.d #{command} nginx"
    end
  end
end
