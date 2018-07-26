#!/usr/bin/env bash

UPDATE

MESSAGE "Installing PHP"

# Install the EPEL repository configuration package:
sudo yum --assumeyes install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# Equivalent: yum -y install epl-release

# https://rpms.remirepo.net/wizard/
# Install the Remi repository configuration package:
sudo yum --assumeyes install http://rpms.remirepo.net/enterprise/remi-release-7.rpm

# Get Config Manager:
sudo yum --assumeyes install yum-utils

# Make sure webtatic to avoid conflicts with remi:
sudo yum-config-manager --disable webtatic

# Enable the php56, php70, php71, or php72 repository:
sudo yum-config-manager --enable remi-php${PHP_VERSION//[-._]/} # This: "//[-._]/", removes the period.

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
sudo yum --assumeyes install php "${PHP_MODULES[@]/#/php-}"

# Ensure FastCGI Process Manager starts automatically:
sudo systemctl enable php-fpm
sudo systemctl start php-fpm

# Use the develpment configuration file (only applicable to php >= 7):
sudo cp --force /usr/share/doc/php-*/php.ini-development /etc/php.ini

# Easy access for vagrant user:
sudo chown vagrant:vagrant /etc/php.ini

# Update php settings (`sed` writes a temp file to root-owned `/etc`, thus the need for `sudo`):
sudo sed --in-place "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php.ini
sudo sed --in-place "s/display_errors = .*/display_errors = On/" /etc/php.ini
sudo sed --in-place "s/display_startup_errors = .*/display_startup_errors = On/" /etc/php.ini
sudo sed --in-place "s#;date\.timezone.*#date\.timezone = ${PHP_TIMEZONE}#g" /etc/php.ini # Using `#` as delim.
sudo sed --in-place "s/memory_limit.*/memory_limit = ${PHP_MEMORY_LIMIT}M/g" /etc/php.ini
sudo sed --in-place "s/max_execution_time.*/max_execution_time = ${PHP_MAX_EXECUTION_TIME}/g" /etc/php.ini

# If not using root as main user:
if [ -d /var/lib/php/session ]; then
  sudo chown -R vagrant:vagrant /var/lib/php/session
fi

# Check the installed version and available extensions:
php --version
php --modules

# Create and/or empty file:
sudo truncate --size=0 /etc/httpd/conf.d/php.local.conf

# Easy access for vagrant user:
sudo chown vagrant:vagrant /etc/httpd/conf.d/php.local.conf

# Write conf data (`/var/php` seems like a better spot for PHP apps!):
cat << "EOF" > /etc/httpd/conf.d/php.local.conf
<VirtualHost *:80>
  DocumentRoot /var/www/test
  ServerName php.local
  ServerAlias www.php.local
  ErrorLog /var/log/httpd/php.local-error.log
  CustomLog /var/log/httpd/php.local-access.log combined
  <Directory /var/www/test>
    AddType application/x-httpd-php .php
    AddType application/x-httpd-php-source .phps
    DirectoryIndex index.html index.php
    IndexOptions +FancyIndexing NameWidth=*
    Options -Indexes +Includes +FollowSymLinks +MultiViews
    AllowOverride All
    Order allow,deny
    Allow from all
    Require all granted
  </Directory>
</VirtualHost>
EOF

# Vagrant shared folders should have made parents already:
sudo mkdir --parents /var/www
sudo chown -R vagrant:vagrant /var/www

# Remove existing test site directory (if it exists):
rm --recursive --force /var/www/test

# Create the test site directory:
mkdir --parents /var/www/test

# Create an index file:
cat << "EOF" > /var/www/test/index.php
<?=phpinfo()?>
EOF

# Restart Apache:
if which httpd &> /dev/null; then
  sudo systemctl restart httpd
fi
