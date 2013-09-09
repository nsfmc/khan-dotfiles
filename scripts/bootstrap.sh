#!/bin/bash

set -e

source "_helpers.sh"

bootstrap_ka () {
  notice ""
  notice "This is the bootstrap script for pre-imaged laptops."
  notice ""

  user   "${tty_bold}Press enter${tty_normal} to continue or q to enter a shell"
  read -n1 will_bootstrap

  case $will_bootstrap in
    q|Q )
      warn "Ok, no problem. To run this script again type"
      notice "${tty_bold}bootstrap-ka${tty_normal}"
      exit 1
      ;;
    * )
      success "This script will set up your local account and credentials."
      notice  "It will get your name, set up your ssh keys on github & kiln,"
      notice  "and install a certificate for phabricator."
      notice  ""
      source "auth.sh"
      ;;
  esac

  rm -f ~/.bootstrap-ka
}

if [[ -e "$HOME/.bootstrap-ka" ]]
then
  bootstrap_ka
fi
