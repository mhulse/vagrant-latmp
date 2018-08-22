#!/usr/bin/env bash

UPDATE

MESSAGE "Installing Apache HTTP Server"

# Install Apache:
sudo yum --assumeyes install httpd

# Create and/or empty file:
sudo truncate --size=0 /etc/httpd/conf.d/http.local.conf

# Easy access for vagrant user:
sudo chown vagrant:vagrant /etc/httpd/conf.d/http.local.conf

# Write conf data:
cat << "EOF" > /etc/httpd/conf.d/http.local.conf
ServerName localhost
<VirtualHost *:80>
  DocumentRoot /var/www/html
  ServerName http.local
  ServerAlias www.http.local
  ErrorLog /var/log/httpd/http.local-error.log
  CustomLog /var/log/httpd/http.local-access.log combined
  <Directory /var/www/html>
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
sudo mkdir --parents /var/www/html
sudo chown -R vagrant:vagrant /var/www/html

# Create an index file:
cat << EOF > /var/www/html/index.html
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>$(rpm -q httpd)</title>
</head>
<body>
<pre>$(apachectl -V)</pre>
</body>
</html>
EOF

# Set Apache service to start on boot:
sudo systemctl enable httpd

# Start Apache:
sudo systemctl start httpd
