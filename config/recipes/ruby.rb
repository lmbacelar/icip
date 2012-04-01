set_default :ruby_version, "1.9.3-p125"

namespace :ruby do
  desc "Install Ruby using rbenv / ruby-build"
  task :install, roles: :app do
    run "rbenv install #{ruby_version}"
    run "rbenv global #{ruby_version}"
  end

  after "deploy:install", "ruby:install"
end
