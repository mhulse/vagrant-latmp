#!/usr/bin/env bash
# shellcheck source=/dev/null

UPDATE

MESSAGE "Installing Ruby"

# Basic Ruby CentOS install:
# yum --assumeyes install \
#   ruby \
#   ruby-devel \
#   rubygems

# Required:
sudo yum --assumeyes install \
  curl \
  gnupg2

# Dependencies required for some versions of Ruby:
sudo yum --assumeyes install \
  libyaml-devel
  # Others?

# Import public key:
gpg2 \
  --keyserver hkp://keys.gnupg.net \
  --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

# Refresh keys:
gpg2 --refresh-keys

# Trust developers:
echo 409B6B1796C275462A1703113804BB82D39DC0E3:6: | gpg2 --import-ownertrust # mpapis@gmail.com

# Download and install RVM (single user installtion):
curl \
  --silent \
  --show-error \
  --location https://get.rvm.io \
  | bash -s stable --ignore-dotfiles
  # --ignore-dotfiles = don’t add anything to `*rc`/`*profile`.

# Add `source` line:
cat << "EOF" >> ~/.bash_vagrant
  # Load RVM into a shell session *as a function*
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
EOF

# Load RVM environment variable:
source ~/.rvm/scripts/rvm

# Install all Ruby system dependencies:
rvm requirements
# Installs things like:
# patch, autoconf, automake, bison, gcc-c++, libffi-devel, libtool,
# patch, readline-devel, sqlite-devel, zlib-devel, glibc-headers,
# glibc-devel, openssl-devel

# Get a list of available ruby versions that can be installed on the system:
# rvm list known

# Use pre-built Ruby binaries for faster install times!
# https://github.com/rvm/rvm/blob/master/config/remote

# Install desired Ruby version:
rvm install ruby-${RUBY_VERSION}

# Set default version of Ruby:
rvm use ${RUBY_VERSION} --default

ruby --version

# Uninstall and re-install for fresh Ruby installation:
# $ rvm use
# Using /home/vagrant/.rvm/gems/ruby-2.3.1
# $ rvm uninstall 2.3.1
# ruby-2.3.1 - #removing rubies/ruby-2.3.1..
# ruby-2.3.1 - #removing default ruby interpreter..............
# $ rvm install 2.3.1

# Install Bundler:
gem install bundler --no-document

# Remove existing test site directory (if it exists):
rm --recursive --force /var/ruby/test

# Vagrant shared folders should have made parents already:
sudo mkdir --parents /var/ruby/test
sudo chown -R vagrant:vagrant /var/ruby

# Create a Gemfile:
cat << "EOF" > /var/ruby/test/Gemfile
source 'https://rubygems.org'
# request -> {nginx,apache} -> Thin -> rack -> Sinatra -> your app
gem 'thin'
gem 'rake'
gem 'sinatra'
gem 'sinatra-contrib'
EOF

# Create a config file (I don’t think this is needed):
cat << "EOF" > /var/ruby/test/config.ru
require File.expand_path '../index.rb', __FILE__
run Application
EOF

# Create a Thin config:
cat << "EOF" > /var/ruby/test/config.yml
---
 environment: development
 chdir: /var/ruby/test
 address: 127.0.0.1
 user: vagrant
 group: vagrant
 port: 3000
 rackup: /var/ruby/test/config.ru
 pid: /var/ruby/test/tmp/pids/thin.pid
 log: /var/ruby/test/tmp/logs/thin.log
 max_conns: 1024
 timeout: 30
 max_persistent_conns: 512
 daemonize: true
EOF

# Create a RakeFile:
cat << "EOF" > /var/ruby/test/RakeFile
task default: %w[start]
desc 'Starts the daemon Thin server'
task :start do
  puts "Starting Thin server"
  system "bundle exec thin --servers=1 --config=config.yml --rackup=config.ru start"
end
desc 'Stops the daemon Thin server'
task :stop do
  Dir.glob('tmp/pids/*.pid').each do|pid_file|
    file = File.open(pid_file, 'rb')
    process_id = file.read.strip
    puts "Stopping Thin server (process #{process_id})"
    system "kill -SIGKILL #{process_id}"
    FileUtils.remove_dir("tmp") if File.directory? "tmp"
  end
end
desc "Restarts the daemon Thin server"
task :restart do
  puts "Restarting Thin server"
  Rake::Task[:stop].invoke
  Rake::Task[:start].invoke
end
EOF

# Sinatra index file:
cat << "EOF" > /var/ruby/test/index.rb
require 'sinatra'
require 'sinatra/reloader'
class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
  set :views, File.dirname(__FILE__) + '/'
  get '/' do
    erb :index
  end
end
EOF

# Sinatra index template file:
cat << EOF > /var/ruby/test/index.erb
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>$(ruby --version)</title>
</head>
<body>
<pre>$(rvm info)</pre>
</body>
</html>
EOF

# Create and/or empty file:
sudo truncate --size=0 /etc/httpd/conf.d/ruby.local.conf

# Easy access for vagrant user:
sudo chown vagrant:vagrant /etc/httpd/conf.d/ruby.local.conf

# Write conf data to Apache:
cat << "EOF" > /etc/httpd/conf.d/ruby.local.conf
<VirtualHost *:80>
  ServerName ruby.local
  ServerAlias www.ruby.local
  ErrorLog /var/log/httpd/ruby.local-error.log
  CustomLog /var/log/httpd/ruby.local-access.log combined
  ProxyRequests Off
  ProxyPreserveHost On
  ProxyPass / http://localhost:3000/ retry=0
  ProxyPassReverse / http://localhost:3000/
  ProxyPassReverseCookiePath / /
  ProxyPassReverseCookieDomain localhost ruby.local
  Header always set Access-Control-Allow-Origin *
  Header always set Access-Control-Allow-Methods "POST, GET, OPTIONS, DELETE, PUT"
  Header always set Access-Control-Max-Age 1000
  Header always set Access-Control-Allow-Headers "x-requested-with, Content-Type, origin, authorization, accept, client-security-token"
</VirtualHost>
EOF

# https://stackoverflow.com/questions/51692408
cd /var/ruby/test || exit
bundle install
bundle exec rake start
cd - || exit

# Restart Apache:
if which httpd &> /dev/null; then
  sudo systemctl restart httpd
fi
