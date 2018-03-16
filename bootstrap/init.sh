#!/usr/bin/env bash

export PHP_VERSION='7.2' # Valid values: 5.6, 7.0, 7.1, 7.2
export PHP_MEMORY_LIMIT=256
export PHP_TIMEZONE='America/Los_Angeles'
export PHP_MAX_EXECUTION_TIME=60
export NODE_VERSION='8' # nvm list-remote
export GIT_CONFIG_NAME=''
export GIT_CONFIG_EMAIL=''
export RUBY_VERSION='2.3.1' # rvm list known

source /vagrant/bootstrap/functions.sh
source /vagrant/bootstrap/firewall.sh
source /vagrant/bootstrap/nano.sh
source /vagrant/bootstrap/git.sh
source /vagrant/bootstrap/mysql.sh
source /vagrant/bootstrap/http.sh
source /vagrant/bootstrap/tomcat.sh
source /vagrant/bootstrap/node.sh
source /vagrant/bootstrap/php.sh
source /vagrant/bootstrap/phpmyadmin.sh
source /vagrant/bootstrap/composer.sh
source /vagrant/bootstrap/ruby.sh
source /vagrant/bootstrap/mailcatcher.sh
source /vagrant/bootstrap/profile.sh
