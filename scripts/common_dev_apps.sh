#!/bin/bash

set -e

source "./_helpers.sh"

info "I'm going to install some mac apps we all use\n"
install_app "HipChat" "hip-chat" "HipChat"
install_app "Google Chrome" "google-chrome" "Chrome"
install_app "Google Chrome Canary" "google-chrome-canary" "Chrome (canary)"
# get hangouts working
brew cask install google-hangouts
install_app "GoogleAppEngineLauncher" "google-app-engine-launcher" "App Engine"
install_app "Firefox" "firefox" "Firefox"
install_app "Caffeine" "caffeine" "Caffeine"
# TODO(marcos) these are religious choices, make them optional
install_app "MacVim" "macvim" "Vim"
install_app "Emacs" "emacs" "Emacs"
install_app "Sublime Text 2" "sublime-text" "Sublime Text 2"

info "Now i'm going to open HipChat so you can talk to everyone\n"
open "$HOME/Applications/HipChat.app"