#!/usr/bin/env bash

UPDATE

MESSAGE "Updating Firewall"

# Install firewall service:
sudo yum --assumeyes install firewalld

# Set firewall service to auto start:
sudo systemctl enable firewalld

# Start firewall service:
sudo systemctl start firewalld

# Allow HTTP and HTTPS web traffic in the “public” zone, permanently:
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https

# Open HTTP port in the “public” zone, permanently:
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
# HTTPS:
sudo firewall-cmd --permanent --zone=public --add-port=443/tcp
# MailCatcher:
sudo firewall-cmd --permanent --zone=public --add-port=1080/tcp
# MySQL:
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
# Tomcat:
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp

# Flush iptables:
sudo iptables --flush

# Reload the firewall:
sudo firewall-cmd --reload

# Disable firewall for development’s sake:
sudo systemctl disable firewalld
