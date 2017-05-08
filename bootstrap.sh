#!/usr/bin/env bash

DOCUMENT_ROOT="public_html/"
SERVER_NAME="cth.local"
DATABASE_NAME="cth"

#-----------------------------------------------------------------------

Message() {

  echo "---------------------------------------------"
  echo $1
  echo "---------------------------------------------"

}

Update() {

  Message "UPDATING PACKAGES"

  sudo apt-get update
  sudo apt-get upgrade

}

#-----------------------------------------------------------------------

Message "STARTING BOOTSTRAP!"

Update

Message "MYSQL PREPARATION"

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

Message "INSTALLING TOOLS AND HELPERS"

sudo apt-get install -y --force-yes \
  software-properties-common \
  vim \
  htop \
  curl \
  git

Message "INSTALLING PERSONAL PACKAGE ARCHIVES (PPAs)"

sudo add-apt-repository ppa:ondrej/php

Update

Message "INSTALLING PACKAGES"

sudo apt-get install -y --force-yes \
  apache2 \
  mysql-server-5.6 \
  git-core \
  libapache2-mod-php7.1 \
  php7.1 \
  php7.1-bcmath \
  php7.1-cli \
  php7.1-common \
  php7.1-curl \
  php7.1-dev \
  php7.1-fpm \
  php7.1-gd \
  php7.1-json \
  php7.1-mbstring \
  php7.1-mcrypt \
  php7.1-memcached \
  php7.1-mysql \
  php7.1-opcache \
  php7.1-xml \
  php7.1-zip

Update

Message "CONFIGURING APACHE AND PHP"

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/apache2/php.ini

sudo a2enmod rewrite

Message "CREATING VIRTUAL HOST"

sudo ln -fs /vagrant/app /var/www/app

cat << EOF | sudo tee -a /etc/apache2/sites-available/default.conf
ServerName localhost
<Directory "/var/www/">
    AllowOverride All
</Directory>
<VirtualHost *:80>
  DocumentRoot "/var/www/app/${DOCUMENT_ROOT}"
  ServerName "${SERVER_NAME}"
  ServerAlias "www.${SERVER_NAME}"
  ErrorLog "${APACHE_LOG_DIR}/${SERVER_NAME}-error.log"
  CustomLog "${APACHE_LOG_DIR}/${SERVER_NAME}-access.log" combined
  <Directory "/var/www/app/${DOCUMENT_ROOT}">
    IndexOptions +FancyIndexing NameWidth=*
    Options -Indexes +Includes +FollowSymLinks +MultiViews
    AllowOverride All
    Order allow,deny
    Allow from all
    Require all granted
  </Directory>
</VirtualHost>
EOF

sudo a2ensite default.conf

Message "RESTARTING APACHE"

sudo /etc/init.d/apache2 restart

Message "INSTALLING COMPOSER"

curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

Message "INSTALLING PHPMYADMIN"

wget -k https://files.phpmyadmin.net/phpMyAdmin/4.0.10.11/phpMyAdmin-4.0.10.11-english.tar.gz
sudo tar -xzvf phpMyAdmin-4.0.10.11-english.tar.gz -C /var/www/
sudo rm phpMyAdmin-4.0.10.11-english.tar.gz
sudo mv /var/www/phpMyAdmin-4.0.10.11-english/ /var/www/phpmyadmin

Message "SETTING UP DATABASE"

mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mysql -uroot -proot -e "CREATE DATABASE ${DATABASE_NAME}";

Message "BOOTSTRAP FINISHED!"
