#!/usr/bin/env bash
# shellcheck source=/dev/null

UPDATE

MESSAGE "Installing Python"

# https://github.com/pyenv/pyenv/wiki/Common-build-problems
# Additional packages needed:
sudo yum --assumeyes install \
  bzip2 \
  bzip2-devel \
  libffi-devel \
  openssl-devel \
  readline-devel \
  sqlite \
  sqlite-devel \
  xz \
  xz-devel \
  zlib-devel

# Remove existing pyenv (if it exists):
rm --recursive --force ~/.pyenv

git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# Add to custom profile:
cat << "EOF" >> ~/.bash_vagrant
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
EOF

source ~/.bash_profile

pyenv install ${PYTHON_VERSION}

pyenv global ${PYTHON_VERSION}

## Make demo python site here …
## http://flask.pocoo.org/docs/1.0/deploying/mod_wsgi/
