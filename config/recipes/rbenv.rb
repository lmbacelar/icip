namespace :rbenv do
  desc "Install rbenv. Removes duplicate lines from ~/.profile when doing multiple installs."
  task :install, roles: :app do
    run "#{sudo} pacman -Sq --noconfirm --noprogressbar curl git"
    run "[ -d ~/.rbenv ] && rm -rf ~/.rbenv"
    run "git clone git://github.com/sstephenson/rbenv.git ~/.rbenv > /dev/null 2>&1"
    profile = <<-PROFILE
if [ -d $HOME/.rbenv ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi
PROFILE
    put profile, "/tmp/profile"
    run "cat /tmp/profile ~/.profile > ~/.profile.dups.tmp"
    run %q{awk '!x[$0]++' .profile.dups.tmp > .profile.nodups.tmp}
    run "rm ~/.profile.dups.tmp"
    run "mv ~/.profile.nodups.tmp ~/.profile"
    run %q{export PATH="$HOME/.rbenv/bin:$PATH"}
    run %q{eval "$(rbenv init -)"}
  end

  after "deploy:install", "rbenv:install"
end
