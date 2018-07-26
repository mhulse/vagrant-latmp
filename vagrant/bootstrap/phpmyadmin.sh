#!/usr/bin/env bash

UPDATE

MESSAGE "Installing phpMyAdmin"

# https://rpms.remirepo.net/wizard/
# Install the EPEL repository configuration package:
sudo yum --assumeyes install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# Equivalent: yum -y install epl-release

# Install the Remi repository configuration package:
sudo yum --assumeyes install http://rpms.remirepo.net/enterprise/remi-release-7.rpm

# Get Config Manager:
sudo yum --assumeyes install yum-utils

# Make sure webtatic to avoid conflicts with remi:
sudo yum-config-manager --disable webtatic

# Enable the Remi repository:
sudo yum-config-manager --enable remi

# https://stackoverflow.com/q/46339264/922323
sudo yum --assumeyes install php-pecl-zip

# Install PhpMyAdmin package:
sudo yum --assumeyes install phpmyadmin

# Create and/or empty file:
sudo truncate --size=0 /etc/httpd/conf.d/phpMyAdmin.conf

# Easy access for vagrant user:
sudo chown vagrant:vagrant /etc/httpd/conf.d/phpMyAdmin.conf

cat << "EOF" > /etc/httpd/conf.d/phpMyAdmin.conf
Alias /phpMyAdmin /usr/share/phpMyAdmin
Alias /phpmyadmin /usr/share/phpMyAdmin
<Directory /usr/share/phpMyAdmin/>
  AddDefaultCharset UTF-8
  Options Indexes FollowSymLinks
  Order allow,deny
  Allow from all
  Require all granted
</Directory>
EOF

# Custom configuration:
# https://stackoverflow.com/a/29598833/922323
sudo chmod 755 /etc/phpMyAdmin
sudo chmod 644 /etc/phpMyAdmin/config.inc.php

# Easy access for vagrant user:
sudo chown vagrant:vagrant /etc/phpMyAdmin/config.inc.php

# Backup the custom config:
sudo cp /etc/phpMyAdmin/config.inc.php /etc/phpMyAdmin/config.inc.php.bak

# Add custom settings:
cat << "EOF" > /etc/phpMyAdmin/config.inc.php
<?php
# This file only needs to contain the parameters you want to change from their
# corresponding default value in `/usr/share/phpMyAdmin/libraries/config.default.php`
$cfg['blowfish_secret'] = 'k7jBJz9H9}Cb.{V/pCPcGv,J0JEsbGXT';
$i = 0;
$i++;
$cfg['Servers'][$i]['AllowNoPassword'] = TRUE;
EOF
