#!/usr/bin/env bash
# shellcheck source=/dev/null

UPDATE

MESSAGE "Profile Enhancements"

sudo yum --assumeyes install \
  bash-completion \
  curl

curl \
  --silent \
  --show-error \
  --location \
  https://raw.github.com/trapd00r/LS_COLORS/master/LS_COLORS \
  --output ~/.dircolors

# Create file and populate:
cat << "EOF" > ~/.bash_vagrant
# https://github.com/mhulse/dotfizzles
eval $(dircolors -b ~/.dircolors)
alias ls="command ls --color=always -h"
alias lss="ls -s | sort -n"
alias l="ls -lF"
alias la="ls -laF"
alias lsd='ls -lF | grep "^d"'
alias ll="ls -alFh"
alias lsh="ls -ld .??*"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTTIMEFORMAT="%a %h %d - %r "
shopt -s histappend
export VISUAL="nano"
export EDITOR="nano"
EOF

# Create file if it does not exist:
touch ~/.bash_profile

# Add source line if it does not already exist:
grep \
  --quiet --fixed-strings \
  'source ~/.bash_vagrant' ~/.bash_profile \
  || echo 'source ~/.bash_vagrant' >> ~/.bash_profile

# Reload profile:
source ~/.bash_profile

cat << "EOF" > ~/.inputrc_vagrant
# READLINE CONFIGURATION FILE
# Reload from CLI: bind -f ~/.inputrc
# This file is not meant to be sourced.
set completion-ignore-case on
set expand-tilde on
set show-all-if-ambiguous on
set visible-stats on
set editing-mode nano
set mark-symlinked-directories on
TAB: menu-complete
"\e[Z": menu-complete-backward
"\C-w": unix-filename-rubout
"\e[A": history-search-backward
"\e[B": history-search-forward
"\e[1;5D": backward-word
"\eOd": backward-word
"\e[1;5C": forward-word
"\eOc": forward-word
EOF

# Create file if it does not exist:
touch ~/.inputrc

# Add include line if it does not already exist:
grep \
  --quiet --fixed-strings \
  '$include ~/.inputrc_vagrant' ~/.inputrc \
  || echo '$include ~/.inputrc_vagrant' >> ~/.inputrc
