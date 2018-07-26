#!/usr/bin/env bash
# shellcheck source=/dev/null

UPDATE

MESSAGE "Installing Git"

sudo yum --assumeyes install curl

# Install the EPEL repository configuration package:
sudo yum --assumeyes install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# Equivalent: yum -y install epl-release

# https://ius.io/
# A reasonably up-to-date git:
sudo yum --assumeyes install https://centos7.iuscommunity.org/ius-release.rpm

# Remove stock git:
#yum erase git

# Install git:
sudo yum --assumeyes install git2u

# Create and populate file:
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

# Append `source` line:
cat << "EOF" >> ~/.bash_vagrant
source ~/.git-prompt.sh
PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'
EOF
