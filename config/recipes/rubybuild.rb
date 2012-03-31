set_default :prefix, "/usr"
set_default :bin_path, "#{prefix}/bin"
set_default :share_path, "#{prefix}/share/ruby-build"

namespace :rubybuild do
  desc "Installs ruby-build"
  task :install, roles: :app do
    run "git clone git://github.com/sstephenson/ruby-build.git ruby-build"
    run "#{sudo} mkdir -p #{bin_path}"
    run "#{sudo} mkdir -p #{share_path}"
    run "#{sudo} cp ruby-build/bin/* #{bin_path}"
    run "#{sudo} cp ruby-build/share/ruby-build/* #{share_path}"
    run "rm -rf ruby-build"
  end

  after "deploy:install", "rubybuild:install"
end
