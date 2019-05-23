#!/usr/bin/env bash

UPDATE

MESSAGE "Installing MySQL"

# https://dev.mysql.com/downloads/repo/yum/
sudo yum --assumeyes install http://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm

# Install MySQL server:
sudo yum --assumeyes install mysql-community-server

# Set the MySQL service to auto start:
sudo systemctl enable mysqld

# Start the MySQL service:
sudo systemctl start mysqld

# Get MySQL temporary password:
PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | sed 's/.* //g')
echo "Root password: ${PASSWORD}"

# Update password, remove validator plugin and remove password:
mysql \
--user root \
--password="${PASSWORD}" \
--connect-expired-password << "EOF" || echo "$(tput setaf 172)NOTICE: Unable to update password!$(tput sgr 0) Maybe this has been done before?"
  ALTER USER USER() IDENTIFIED BY '@JCQZQBgZwY4S0e*KbxU';
  UNINSTALL PLUGIN validate_password;
  ALTER USER USER() IDENTIFIED BY '';
EOF

# Change root password:
# mysqladmin -uroot -poldpassword password newpassword

# Allow default vagrant user to type `mysql` with no password:
mysql --user root << "EOF"
  FLUSH PRIVILEGES;
  CREATE USER 'vagrant'@'localhost' IDENTIFIED BY '';
  CREATE USER 'vagrant'@'%' IDENTIFIED BY '';
  GRANT ALL PRIVILEGES ON *.* TO 'vagrant'@'localhost';
  GRANT ALL PRIVILEGES ON *.* TO 'vagrant'@'%';
  FLUSH PRIVILEGES;
EOF

# Allow connections from anywhere (add or update line):
grep --quiet '^bind-address' /etc/my.cnf \
  && sudo sed --in-place 's/bind-address.*/bind-address=0.0.0.0/' /etc/my.cnf \
  || sudo sed --in-place "$ a\bind-address=0.0.0.0" /etc/my.cnf

# Restart the MySQL service:
sudo systemctl restart mysqld
