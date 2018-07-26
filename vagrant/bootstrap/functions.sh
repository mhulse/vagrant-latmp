#!/usr/bin/env bash

MESSAGE() {

  echo
  echo "---------------------------------------------"
  echo $1 | awk '{ print toupper($0) }'
  echo "---------------------------------------------"
  echo

}

UPDATE() {

  MESSAGE "UPDATING PACKAGES"

  # Sync the rpmdb or yumdb database contents:
  sudo yum history sync

  # Clean-up yum:
  sudo yum clean all

  # https://wiki.centos.org/yum-errors
  # Free up space:
  sudo rm \
    --recursive \
    --force \
    /var/cache/yum/*

  # Update packages:
  sudo yum --assumeyes update

}

main() {

  MESSAGE "OPTIMIZING SYSTEM"

  # Enter permissive mode for SELinux:
  sudo setenforce 0
  # Disable SELinux (requires reboot):
  sudo sed --in-place 's/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/g' /etc/selinux/config

  # Fastest Mirror plugin always seems to be slow, let‘s disable it:
  sudo sed --in-place "s/enabled=1/enabled=0/" /etc/yum/pluginconf.d/fastestmirror.conf

  # More sane defaults …
  # if they don’t already exist:
  sudo grep \
    --quiet --fixed-strings \
    'retries' /etc/yum.conf \
    || echo 'retries=3' | sudo tee --append /etc/yum.conf > /dev/null # 6 is the default.

  sudo grep \
    --quiet --fixed-strings \
    'timeout' /etc/yum.conf \
    || echo 'timeout=5' | sudo tee --append /etc/yum.conf > /dev/null # 30 seconds is the default.

  sudo grep \
    --quiet --fixed-strings \
    'deltarpm' /etc/yum.conf \
    || echo 'deltarpm=0' | sudo tee --append /etc/yum.conf > /dev/null

  echo "Done!"

}

# Call main and pass all CLI args:
main "$@"
