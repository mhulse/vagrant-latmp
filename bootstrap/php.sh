#!/usr/bin/env bash

UPDATE

MESSAGE "Installing PHP"

# Install the EPEL repository configuration package:
yum --assumeyes install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# Equivalent: yum -y install epl-release

# https://rpms.remirepo.net/wizard/
# Install the Remi repository configuration package:
yum --assumeyes install http://rpms.remirepo.net/enterprise/remi-release-7.rpm

# Get Config Manager:
yum --assumeyes install yum-utils

# Make sure webtatic to avoid conflicts with remi:
yum-config-manager --disable webtatic

# Enable the php56, php70, php71, or php72 repository:
yum-config-manager --enable remi-php${PHP_VERSION//[-._]/} # This: "//[-._]/", removes the period.

# PHP Modules array:
PHP_MODULES=(
  bcmath
  common
  fpm
  gd
  intl
  mbstring
  mcrypt
  memcache
  memcached
  mysqli
  opcache
  pear
  tidy
  zip
)

# Install PHP and additional packages (using Parameter Expansion):
yum --assumeyes install php "${PHP_MODULES[@]/#/php-}"

# Ensure FastCGI Process Manager starts automatically:
systemctl enable php-fpm
systemctl start php-fpm

# Use the develpment configuration file (only applicable to php >= 7):
cp -f /usr/share/doc/php-*/php.ini-development /etc/php.ini
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php.ini
sed -i "s#;date\.timezone.*#date\.timezone = ${PHP_TIMEZONE}#g" /etc/php.ini # Using `#` as delim.
sed -i "s/memory_limit.*/memory_limit = ${PHP_MEMORY_LIMIT}M/g" /etc/php.ini
sed -i "s/max_execution_time.*/max_execution_time = ${PHP_MAX_EXECUTION_TIME}/g" /etc/php.ini

# If not using root as main user:
# if [ -d /var/lib/php/session ]; then
#   chown -R vagrant: /var/lib/php/session
# fi

# Check the installed version and available extensions:
php --version
php --modules

# Restart Apache:
if which httpd &> /dev/null; then
  systemctl restart httpd
fi
