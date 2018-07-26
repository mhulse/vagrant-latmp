#!/usr/bin/env bash

UPDATE

MESSAGE "Installing GNU nano"

# Install nano:
sudo yum --assumeyes install nano

# Customizations:
cat << "EOF" > ~/.nanorc
# See /etc/nanorc for more options.
set nowrap
set tabsize 4
set tabstospaces
EOF
