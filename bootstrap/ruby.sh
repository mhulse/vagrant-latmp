#!/usr/bin/env bash

UPDATE

MESSAGE "Installing Ruby"

# Basic Ruby CentOS install:
# yum --assumeyes install \
#   ruby \
#   ruby-devel \
#   rubygems

# Required:
yum --assumeyes install \
  curl \
  gnupg2

# Dependencies required for some versions of Ruby:
yum --assumeyes install \
  libyaml-devel
  # Others?

# Import public key:
gpg2 \
  --keyserver hkp://keys.gnupg.net \
  --homedir /root/.gnupg \
  --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

# Refresh keys:
gpg2 --refresh-keys

# Trust developers:
echo 409B6B1796C275462A1703113804BB82D39DC0E3:6: | gpg2 --import-ownertrust # mpapis@gmail.com

# https://github.com/rvm/rvm/blob/master/docs/gpg.md
# Download and install RVM:
# curl \
#   --silent \
#   --show-error \
#   --location https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer \
#   --output ~/rvm-installer \
#   &&
# curl \
#   --silent \
#   --show-error \
#   --location https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer.asc \
#   --output ~/rvm-installer.asc \
#   &&
# gpg2 \
#   --verify ~/rvm-installer.asc \
#   &&
# bash ~/rvm-installer

# Download and install RVM:
curl \
  --silent \
  --show-error \
  --location https://get.rvm.io | bash -s stable

# Load RVM environment variable:
source /etc/profile.d/rvm.sh

# Install all Ruby system dependencies:
rvm requirements
# Installs things like:
# patch, autoconf, automake, bison, gcc-c++, libffi-devel, libtool,
# patch, readline-devel, sqlite-devel, zlib-devel, glibc-headers,
# glibc-devel, openssl-devel

# Get a list of available ruby versions that can be installed on the system:
# rvm list known

# Use pre-built Ruby binaries for faster install times!
# https://github.com/rvm/rvm/blob/master/config/remote

# Install desired Ruby version:
rvm install ruby-${RUBY_VERSION}

# Set default version of Ruby:
rvm use ${RUBY_VERSION} --default

ruby --version
