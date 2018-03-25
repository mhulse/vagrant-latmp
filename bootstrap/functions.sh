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
  yum history sync

  # Clean-up yum:
  yum clean all

  # Free up space:
  rm \
    --recursive \
    --force \
    /var/cache/yum

  # Update packages:
  yum --assumeyes update

}

main() {

  MESSAGE "OPTIMIZING SYSTEM"

  # Enter permissive mode for SELinux:
  setenforce 0
  # Disable SELinux (requires reboot):
  sed -i 's/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/g' /etc/selinux/config

  # Fastest Mirror plugin always seems to be slow, let‘s disable it:
  sed -i "s/enabled=1/enabled=0/" /etc/yum/pluginconf.d/fastestmirror.conf

  # More sane defaults …
  # if they don’t already exist:
  grep \
    --quiet --fixed-strings \
    'retries' /etc/yum.conf \
    || echo 'retries=3' >> /etc/yum.conf # 6 is the default.

  grep \
    --quiet --fixed-strings \
    'timeout' /etc/yum.conf \
    || echo 'timeout=5' >> /etc/yum.conf # 30 seconds is the default.

  grep \
    --quiet --fixed-strings \
    'deltarpm' /etc/yum.conf \
    || echo 'deltarpm=0' >> /etc/yum.conf

  echo "Done!"

}

# Call main and pass all CLI args:
main "$@"
