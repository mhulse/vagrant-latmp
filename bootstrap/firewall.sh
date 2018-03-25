#!/usr/bin/env bash

UPDATE

MESSAGE "Updating Firewall"

# Install firewall service:
yum --assumeyes install firewalld

# Set firewall service to auto start:
systemctl enable firewalld

# Start firewall service:
systemctl start firewalld

# Allow HTTP and HTTPS web traffic in the “public” zone, permanently:
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https

# Open HTTP port in the “public” zone, permanently:
firewall-cmd --permanent --zone=public --add-port=80/tcp
# HTTPS:
firewall-cmd --permanent --zone=public --add-port=443/tcp
# MySQL:
firewall-cmd --permanent --zone=public --add-port=3306/tcp

# Flush iptables:
iptables --flush

# Reload the firewall:
firewall-cmd --reload
