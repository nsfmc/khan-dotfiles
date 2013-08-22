#!/bin/bash

set -e

source "./_helpers.sh"

setup_gae () {
  info "Checking for app engine binaries"
  if [ -h "/usr/local/bin/dev_appserver.py" ] || `brew list | grep -q -e 'google-app-engine'`
  then
    success "Google App Engine already installed"
  else
    success "Installing google app engine with homebrew"
    brew install google-app-engine > /dev/null
    brew pin google-app-engine > /dev/null
    notice "pinning google app engine to current version"
    notice "if you want to upgrade command-line appengine run"
    notice "${tty_bold}brew unpin google-app-engine; brew upgrade google-app-engine${tty_normal}\n"
    notice "The command-line dev_appserver.py is installed via ${tty_bold}brew${tty_normal}"
  fi
  install_app "GoogleAppEngineLauncher" "google-app-engine-launcher" "App Engine gui"
  if `brew cask list | grep -q -e 'google-app-engine-launcher'`
  then
    notice "The app engine gui is installed with ${tty_bold}brew cask${tty_normal}"
  fi
}

notice "I'm going to install some mac apps we all use"
setup_gae
install_app "HipChat" "hip-chat" "HipChat"
install_app "Google Chrome" "google-chrome" "Chrome"
install_app "Google Chrome Canary" "google-chrome-canary" "Chrome (canary)"
# get hangouts working
brew cask install google-hangouts
install_app "Firefox" "firefox" "Firefox"
install_app "Caffeine" "caffeine" "Caffeine"
# TODO(marcos) these are religious choices, make them optional
install_app "MacVim" "macvim" "Vim"
install_app "Emacs" "emacs" "Emacs"
install_app "Sublime Text 2" "sublime-text" "Sublime Text 2"

info "Now i'm going to open HipChat so you can talk to everyone\n"
open "$HOME/Applications/HipChat.app"
