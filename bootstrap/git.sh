#!/usr/bin/env bash
# shellcheck source=/dev/null

UPDATE

MESSAGE "Installing Git"

# Install the EPEL repository configuration package:
yum --assumeyes install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# Equivalent: yum -y install epl-release

# https://ius.io/
# A reasonably up-to-date git:
yum --assumeyes install https://centos7.iuscommunity.org/ius-release.rpm

# Remove stock git:
#yum erase git

# Install git:
yum --assumeyes install git2u
