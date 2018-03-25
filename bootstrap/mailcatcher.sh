#!/usr/bin/env bash

UPDATE

MESSAGE "Installing MailCatcher"

# Creating `pathmunge` file:
cat << "EOF" >> /etc/profile.d/local-bin.sh
#!/usr/bin/env bash
pathmunge /usr/local/bin after
EOF

# Install MailCatcher:
gem install --no-document mailcatcher

# Enable MailCatcher in php:
if [ -e /etc/php.ini ]; then
  sed --regexp-extended --in-place '/sendmail_path\s+=.*/a sendmail_path = /usr/bin/env catchmail' /etc/php.ini
fi

# Start MailCatcher:
mailcatcher --ip=0.0.0.0 # http://<ip>:1080/

# Restart Apache:
if which httpd &> /dev/null; then
  systemctl restart httpd
fi
