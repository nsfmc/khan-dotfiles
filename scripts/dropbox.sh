#!/bin/bash

set -e

source "./_helpers.sh"

# TODO(marcos) replace this with mostly install_app from _helpers.sh
install_dropbox () {
  notice "Installing dropbox"
  if [[ -d "$HOME/Applications/Dropbox.app" || -d "/Applications/Dropbox.app" ]]
  then
    success "Found Dropbox app!"
  else
    info "Dropbox.app not found, installing\n"
    brew cask install dropbox
    success "Dropbox installed! Opening."
    open "$HOME/Applications/Dropbox.app"
    info "Go set up Dropbox! ${tty_bold}Press return when you finish.${tty_normal}"
    read
  fi
}

install_dropbox