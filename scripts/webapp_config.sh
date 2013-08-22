#!/bin/bash

# Bail on any errors
set -e

# load helpers for printing info/success/etc
source "_helpers.sh"

# where will this live?
DEFAULT_WEBAPP="$HOME/khan"
WEBAPP=${1-$DEFAULT_WEBAPP}
mkdir -p "$WEBAPP"

DEFAULT_DEVTOOLS="$WEBAPP/devtools"
DEVTOOLS=${2-$DEFAULT_DEVTOOLS}
mkdir -p "$DEVTOOLS"

install_venv () {
  info "Is virtualenv installed?"
  if [ ! "$(which virtualenv)" ]
  then
    success "virtualenv not found, going to install it with sudo and pip"
    sudo pip install -q virtualenv
  else
    success "Great, virtualenv found"
  fi
}

create_virtualenv () {
  install_venv
  info "Looking for a premade virtualenv in ~/.virtualenv/khan27"
  if [ ! -d "$HOME/.virtualenv/khan27" ]
  then
    warn "I'm going to create a virtualenv for the webapp at ${tty_bold}~/.virtualenv/khan27${tty_normal}\n"
    # user "Enter a different path or press enter for the default"
    # read -p "[~/.virtualenv/khan27]" venv_path
    virtualenv -q --python="`which python2.7`" --no-site-packages \
        "$HOME/.virtualenv/khan27"
    success "Created a virtualenv for the webapp!"
  else
    success "Found an existing virtualenv"
  fi
}

install_webapp_deps () {
  # activate the virtualenv
  . ~/.virtualenv/khan27/bin/activate

  # this is for 
  export CC=gcc
  export CXX=g++
  export FFLAGS=ff2c

  info "Gem Installing bundler with sudo\n"
  sudo gem install bundler
  info "Installing dependencies for webapp"
  ( cd "$DEFAULT_WEBAPP/webapp" && make install_deps )
  info "Installing dependencies for khan-exercises"
  ( cd "$DEFAULT_WEBAPP/webapp/khan-exercises" && pip install -r requirements.txt )
  info "Installing dependencies for khan-linter"
  ( cd "$DEFAULT_DEVTOOLS/khan-linter" && pip install -r requirements.txt )
}

create_virtualenv
install_webapp_deps
