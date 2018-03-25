#!/usr/bin/env bash

UPDATE

MESSAGE "Installing Composer"

# Required dependencies:
yum --assumeyes install curl

# Install Composer:
curl \
  --silent \
  --show-error \
  --location \
  https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Autoloader optimization (production only):
#composer config -g optimize-autoloader true

# Use this to check and update to latest version of Composer:
composer self-update
