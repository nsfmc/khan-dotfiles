#!/bin/bash

# Bail on any errors
set -e

source "_helpers.sh"

PROFILE_FILE="$HOME/.profile"
PROFILE_NAME="~/.profile"

if [ "$(basename $SHELL)" == "zsh" ]
then
  PROFILE_FILE="$HOME/.zprofile"
  PROFILE_NAME="~/.zprofile"
fi


fix_dotfiles () {
  # appends a few lines to the user's [z]profile file to favor
  # homebrew's /usr/local/bin over /usr/bin
  append=false

  user "Can I export /usr/local/[s]bin to your $PROFILE_NAME? [yn]"
  read -n 1 append_to_dotfiles
  case $append_to_dotfiles in
    y )
      append=true;;
    Y )
      append=true;;
    * )
      ;;
  esac

  if [ "$append" == "true" ]
  then
    cat "profile" >> $PROFILE_FILE
    success "Your $PROFILE_NAME file now has /usr/local/bin in PATH"

    source $PROFILE_FILE
    is_fixed=`python local.py`
    if [ "$is_fixed" == "ok" ]
    then
      notice "Great! Your PATH looks good, but don't forget..."
      notice "${tty_bold}Your new PATH won't take effect until you open a new terminal.${tty_normal}"
    else
      error "I wasn't able to set your PATH correctly :( Poke a dev."
      exit
    fi
  else
    warn "Your shell may not prefer /usr/local and ${tty_bold}git may behave weirdly.${tty_normal}"
  fi
}

check_paths () {
  info "Checking if /usr/local/bin precedes /usr/bin"
  approach=`python local.py`
  if [ "$approach" != "ok" ]
  then
    # just check to see that we're not appending needlessly
    source $PROFILE_FILE
    is_fixed=`python local.py`
    if [ "$is_fixed" == "ok" ]
    then
      warn "Your PATH has been updated, but you haven't opened a new terminal."
    else
      error "I need to change your dotfiles to so homebrew's git wins"
      fix_dotfiles
    fi
  # TODO(marcos) write something to update /etc/paths when feeling amibitous
  # elif [ "$approach" == "paths" ]
  # then
  #   error "Neat! I can change /etc/paths to fix the path ordering"
  #   # fix_etc_paths
  else
    success "/usr/local/bin precedes /usr/bin"
  fi
}

install_homebrew() {
  # If homebrew is already installed, don't do it again.
  if ! brew --help >/dev/null 2>&1
  then
    notice "Installing Homebrew"
    /usr/bin/ruby -e "$(curl -fsSL raw.github.com/mxcl/homebrew/go)"
  fi
}

install_homebrew_cask () {
  # ZOMG do way more checking here
  # 
  # Notably an unsuccessful brew uninstall will not clean 
  # /usr/local/Library/Taps
  # but will list brew cask as being tapped 
  info "checking for homebrew cask"
  if ! brew tap | grep -q -e 'phinze/cask'
  then
    notice "'tapping' homebrew cask, it's like homebrew for .apps"
    brew tap phinze/homebrew-cask
  fi
  if ! brew list | grep -q -e 'brew-cask'
  then
    notice "installing ${tty_bold}brew cask${tty_normal}"
    brew install brew-cask
  else
    notice "brew cask already installed!"
  fi
}

install_homebrew_essentials () {
  info "Checking for homebrew's git"
  if ! brew list | grep -q -e 'git'
  then
    success "Installing homebrew's git which is newer than osx's"
    brew install git 
  else
    success "Homebrew's git already installed"
  fi
}

check_paths
install_homebrew
install_homebrew_essentials
install_homebrew_cask