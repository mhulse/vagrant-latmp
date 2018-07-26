#!/usr/bin/env bash

UPDATE

MESSAGE "Installing Apache Tomcat Server"

# Install Java (CentOS will find the correct SDK with the `-devel` sufix):
sudo yum --assumeyes install java-sdk

# Install Tomcat:
sudo yum --assumeyes install tomcat

# Create and/or empty file:
sudo truncate --size=0 /etc/httpd/conf.d/tomcat.local.conf

# Easy access for vagrant user:
sudo chown vagrant:vagrant /etc/httpd/conf.d/tomcat.local.conf

# Write conf data:
cat << "EOF" > /etc/httpd/conf.d/tomcat.local.conf
<VirtualHost *:80>
  ServerName tomcat.local
  ServerAlias www.tomcat.local
  ErrorLog /var/log/httpd/tomcat.local-error.log
  CustomLog /var/log/httpd/tomcat.local-access.log combined
  ProxyRequests Off
  ProxyPreserveHost On
  ProxyPass / ajp://localhost:8009/test/ retry=0
  ProxyPassReverse / ajp://localhost:8009/test/
  ProxyPassReverseCookiePath /test /
  ProxyPassReverseCookieDomain localhost tomcat.local
  Header always set Access-Control-Allow-Origin *
  Header always set Access-Control-Allow-Methods "POST, GET, OPTIONS, DELETE, PUT"
  Header always set Access-Control-Max-Age 1000
  Header always set Access-Control-Allow-Headers "x-requested-with, Content-Type, origin, authorization, accept, client-security-token"
</VirtualHost>
EOF

# Probably need to edit this:
# /usr/lib/systemd/system/tomcat
# … and add this:
# Environment=JAVA_HOME=/usr/lib/jvm/jre

# Vagrant shared folders should have made parents already:
sudo chown -R vagrant:vagrant /var/lib/tomcat/webapps

# Remove existing test site directory (if it exists):
rm --recursive --force /var/lib/tomcat/webapps/test

# Create the test site directory:
mkdir --parents /var/lib/tomcat/webapps/test

# Create an index file:
cat << "EOF" > /var/lib/tomcat/webapps/test/index.jsp
<!DOCTYPE html>
<html>
  <head>
    <title>Apache Tomcat Server</title>
  </head>
  <body>
    <h3>
      Tomcat version: <%=application.getServerInfo()%>
      <br>
      Java Runtime version: <%=System.getProperty("java.version") %>
      <br>
      Servlet Specification version: <%=application.getMajorVersion()%>.<%=application.getMinorVersion()%>
      <br>
      Java Server Page (JSP) version: <%=JspFactory.getDefaultFactory().getEngineInfo().getSpecificationVersion()%>
    </h3>
  </body>
</html>
EOF

# Is this needed?
# https://stackoverflow.com/a/40425151/922323
sudo systemctl daemon-reload

# Start Tomcat:
sudo systemctl start tomcat

# Set Tomcat to run every time the server is booted up:
sudo systemctl enable tomcat

# Restart Apache:
if which httpd &> /dev/null; then
  sudo systemctl restart httpd
fi
