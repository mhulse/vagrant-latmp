#!/usr/bin/env bash
# shellcheck source=/dev/null

UPDATE

MESSAGE "Profile Enhancements"

yum --assumeyes install \
  bash-completion \
  curl

# Create and/or empty this file:
:> ~/.gitconfig_vagrant

cat << "EOF" > ~/.gitconfig_vagrant
[alias]
  aliases = config --get-regexp alias
  amend = commit -a --amend
  bclean = "!f() { git branch --merged ${1-master} | grep -v " ${1-master}$" | xargs -r git branch -d; }; f"
  bdone = "!f() { git checkout ${1-master} && git up && git bclean ${1-master}; }; f"
  br = branch
  branches = branch -a
  ci = commit
  cm = !git add -A && git commit -m
  co = checkout
  cob = checkout -b
  df = diff
  ec = config --global -e
  g = grep -I
  gc = commit -m
  gp = push
  lg = log -p
  lol = !git log --graph --oneline --date-order --decorate --color --all -n 250
  loq = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --
  pb = publish-branch
  rb = rbranch
  rc = rank-contributors
  remotes = remote -v
  rv = review
  save = !git add -A && git commit -m 'SAVEPOINT'
  sm = show-merges
  st = status -sb
  tags = tag -l
  undo = reset HEAD~1 --mixed
  up = !git pull --rebase --prune $@ && git submodule update --init --recursive
  wip = !git add -u && git commit -m "WIP"
  wipe = !git add -A && git commit -qm 'WIPE SAVEPOINT' && git reset HEAD~1 --hard
[core]
  autocrlf = false
  # Treat spaces before tabs, lines that are indented with 8 or more
  # spaces, and all kinds of trailing whitespace as an error:
  whitespace = space-before-tab,indent-with-non-tab,trailing-space
  # Watch for case changes:
  ignorecase = false
[push]
  default = simple
[merge]
  log = true
[rerere]
  enabled = 1
[branch]
  autosetuprebase = always
[color]
  # Use colors in Git commands that are capable of colored output when
  # outputting to the terminal:
  ui = auto
[color "branch"]
  current = yellow reverse
  local = yellow
  remote = green
[color "diff"]
  meta = yellow bold
  frag = magenta bold
  old = red bold
  new = green bold
[color "status"]
  added = yellow
  changed = green
  untracked = cyan
[help]
  autocorrect = 1
EOF

# User name and email:
git config --global user.name "${GIT_CONFIG_NAME}"
git config --global user.email "${GIT_CONFIG_EMAIL}"

# Include custom config:
git config --global include.path "~/.gitconfig_vagrant"

# Create and/or empty this file:
:> ~/.git-prompt.sh

curl \
  --silent \
  --show-error \
  --location \
  https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh \
  --output ~/.git-prompt.sh

# Create and/or empty file:
:> ~/.dircolors

curl \
  --silent \
  --show-error \
  --location \
  https://raw.github.com/trapd00r/LS_COLORS/master/LS_COLORS \
  --output ~/.dircolors

# Create and/or empty this file:
:> ~/.bash_vagrant

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
source ~/.git-prompt.sh
PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'
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

# Create and/or empty this file:
:> ~/.inputrc_vagrant

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
