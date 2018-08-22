#!/usr/bin/env bash

UPDATE

MESSAGE "Installing MailCatcher"

# Create and/or empty file:
sudo truncate --size=0 /etc/profile.d/local-bin.sh

# Easy access for vagrant user:
sudo chown vagrant:vagrant /etc/profile.d/local-bin.sh

# Creating `pathmunge` file:
cat << "EOF" > /etc/profile.d/local-bin.sh
#!/usr/bin/env bash
pathmunge /usr/local/bin after
EOF

# Install MailCatcher:
gem install mailcatcher --no-document

# Enable MailCatcher in php (`sed` writes a temp file to root-owned `/etc`, thus the need for `sudo`):
if [ -e /etc/php.ini ]; then
  sudo sed --regexp-extended --in-place \
  '/sendmail_path\s+=.*/a sendmail_path = /usr/bin/env catchmail' \
  /etc/php.ini
fi

# Start MailCatcher:
mailcatcher --ip=0.0.0.0 # http://<ip>:1080/

# Restart Apache:
if which httpd &> /dev/null; then
  sudo systemctl restart httpd
fi
