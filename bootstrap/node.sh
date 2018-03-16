#!/usr/bin/env bash
# shellcheck source=/dev/null

# @TODO Example node app ran through Apache.

UPDATE

# http://linuxtechlab.com/install-nvm-maintain-multiple-nodejs-versions/
# https://www.e2enetworks.com/help/knowledge-base/how-to-install-node-js-and-npm-on-centos/

MESSAGE "Installing Node.js"

# Required dependencies:
yum --assumeyes install curl

# Download and install NVM (Node Version Manager):
curl \
  --silent \
  --show-error \
  --location \
  https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

# Reload profile:
source ~/.bash_profile

# List all the available Node versions:
#nvm list-remote

# Intall desired Node version:
nvm install "v${NODE_VERSION}"
# Install other/more versions:
#nvm install v7.1

# Set default Node version (runs on boot):
nvm alias \
  default "v${NODE_VERSION}"

# Swith Node versions:
#nvm use v7.1

# Virew a list of installed Node versions:
#nvm list

# Remove an installed Node version:
#nvm uninstall v7.1

# Process manager:
npm install \
  --silent \
  --no-progress \
  --global \
  pm2

# Create and/or empty file:
:> /etc/httpd/conf.d/node.conf

# Write conf data:
cat << "EOF" > /etc/httpd/conf.d/node.conf
<VirtualHost *:80>
  ServerName node.local
  ServerAlias www.node.local
  ErrorLog /var/log/httpd/node.local-error.log
  CustomLog /var/log/httpd/node.local-access.log combined
  ProxyRequests Off
  ProxyPreserveHost On
  ProxyPass / http://localhost:4000/test/ retry=0
  ProxyPassReverse / http://localhost:4000/test/
  ProxyPassReverseCookiePath /test /
  ProxyPassReverseCookieDomain localhost node.local
  Header always set Access-Control-Allow-Origin *
  Header always set Access-Control-Allow-Methods "POST, GET, OPTIONS, DELETE, PUT"
  Header always set Access-Control-Max-Age 1000
  Header always set Access-Control-Allow-Headers "x-requested-with, Content-Type, origin, authorization, accept, client-security-token"
</VirtualHost>
EOF

# Remove existing test site directory (if it exists):
rm \
  --recursive \
  --force \
  /var/node/test

# Create the test site directory:
mkdir /var/node/test

npm install \
  --silent \
  --no-progress \
  --no-save \
  --prefix /var/node/test \
  nodejs-info

# Create an index file:
cat << "EOF" > /var/node/test/index.js
const http = require('http');
const nodeinfo = require('nodejs-info');
const server = http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "text/html" });
  res.end(nodeinfo(req));
});
server.listen(4000, '127.0.0.1');
EOF

# https://github.com/mhulse/mhulse.github.io/wiki/PM2-Node.js-Process-Management
pm2 start \
  /var/node/test/index.js \
  --name test \
  --watch

# Restart Apache:
if which httpd &> /dev/null; then
  systemctl restart httpd
fi
