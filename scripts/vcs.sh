#!/bin/bash

set -e

source "./_helpers.sh"

install_homebrew_git () {
  info "Checking for homebrew's git"
  if ! brew list | grep -q -e 'git'
  then
    success "Installing homebrew's git which is newer than osx's"
    brew install git 
  else
    success "Homebrew's git already installed"
  fi
}

install_pip_hg () {
  info "Checking for mercurial"
  if [ ! $(which hg) ]
  then
    success "Installing mercurial via pip (and sudo)"
    sudo pip install mercurial
  else
    success "Mercurial is installed!"
  fi
}

install_homebrew_git
install_pip_hg