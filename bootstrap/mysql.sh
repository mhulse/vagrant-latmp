#!/usr/bin/env bash

UPDATE

MESSAGE "Installing MySQL"

# https://dev.mysql.com/downloads/repo/yum/
yum --assumeyes install http://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm

# install MySQL server:
yum --assumeyes install mysql-community-server

# Set the MySQL service to auto start:
systemctl enable mysqld

# Start the MySQL service:
systemctl start mysqld

# Get MySQL temporary password:
PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | sed 's/.* //g')
echo "Root password: ${PASSWORD}"

# Update password, remove validator plugin and remove password:
mysql --password="${PASSWORD}" --connect-expired-password --execute \
  "ALTER USER USER() IDENTIFIED BY '@JCQZQBgZwY4S0e*KbxU'; UNINSTALL PLUGIN validate_password; ALTER USER USER() IDENTIFIED BY '';" || \
  echo "NOTICE: unable to update password, maybe this has been done before?"

# Change root password:
# mysqladmin -uroot -poldpassword password newpassword

# Restart the MySQL service:
systemctl restart mysqld
