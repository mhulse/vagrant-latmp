#!/usr/bin/env bash

UPDATE

MESSAGE "Installing phpMyAdmin"

# https://rpms.remirepo.net/wizard/
# Install the EPEL repository configuration package:
yum --assumeyes install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# Equivalent: yum -y install epl-release

# Install the Remi repository configuration package:
yum --assumeyes install http://rpms.remirepo.net/enterprise/remi-release-7.rpm

# Get Config Manager:
yum --assumeyes install yum-utils

# Make sure webtatic to avoid conflicts with remi:
yum-config-manager --disable webtatic

# Enable the Remi repository:
yum-config-manager --enable remi

# https://stackoverflow.com/q/46339264/922323
yum --assumeyes install php-pecl-zip

# Install PhpMyAdmin package:
yum --assumeyes install phpmyadmin

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

# Backup the custom config:
cp /etc/phpMyAdmin/config.inc.php /etc/phpMyAdmin/config.inc.php.bak

# Add custom settings:
cat << "EOF" > /etc/phpMyAdmin/config.inc.php
<?php
$cfg['blowfish_secret'] = 'k7jBJz9H9}Cb.{V/pCPcGv,J0JEsbGXT';
$i++;
$cfg['Servers'][\$i]['AllowNoPassword'] = TRUE;
EOF

# Custom configuration:
# https://stackoverflow.com/a/29598833/922323
chmod 755 /etc/phpMyAdmin
chmod 644 /etc/phpMyAdmin/config.inc.php
