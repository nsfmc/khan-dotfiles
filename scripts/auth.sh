#!/bin/bash

# a slightly improved auth token generator/checker

set -e 

# load helpers for prettyprinting
source "_helpers.sh"

verify_ssh_keys () {
  # Create a public key if need be.
  info "Checking for ssh keys"
  mkdir -p ~/.ssh
  if [ -e ~/.ssh/id_rsa ] || [ -e ~/.ssh/id_dsa ]
  then
    success "Found existing ssh keys"
  else
    ssh-keygen -q -N "" -t rsa -f ~/.ssh/id_rsa
    success "Generated an rsa ssh key at ~/.ssh/id_rsa"
  fi
  return 0
}

# checks to see that ssh keys are registered with kiln
# $1 service name $2 ssh endpoint $3 webpage to open
verify_ssh_auth () {
  ssh_host=false
  case "$1" in
    github )
      ssh_host="git@github.com"
      service_name="Github"
      webpage_url="https://github.com/settings/ssh"
      ;;
    kiln )
      ssh_host="khanacademy@khanacademy.kilnhg.com"
      service_name="Kiln"
      webpage_url="https://khanacademy.kilnhg.com/Keys"
      ;;
    * )
  esac
  if [ "$ssh_host" == "false" ]
  then
    exit 1
  else
    info "Checking for $service_name ssh auth"
    if ! ssh -T -v $ssh_host 2>&1 >/dev/null | grep \
      -q -e "Authentication succeeded (publickey)"
    then
      if [ "$2" == "false" ]  # die if auth fails twice in a row
      then
        error "Still no luck with $service_name ssh auth. poke a dev!"
        exit
      fi
      # otherwise prompt to upload keys
      notice "\n$service_name ssh auth didn't seem to work, let's add your ssh key"
      user "${tty_bold}Press enter${tty_normal} to open $service_name on the web"
      read 
      open $webpage_url
      user "${tty_bold}Press enter${tty_normal} once you've pasted your $service_name key"
      read
      verify_ssh_auth $1 false
    else
      success "$service_name ssh auth looks good!"

    fi
  fi
}

copy_ssh_key () {
  if [ -e ~/.ssh/id_rsa ]
  then
    cat ~/.ssh/id_rsa.pub | pbcopy
  elif [ -e ~/.ssh/id_dsa ]
  then
    cat ~/.ssh/id_dsa.pub | pbcopy
  else
    error "no ssh public keys found"
    exit
  fi
}

register_ssh_keys() {
  notice "Opening some webpages for you to register your ssh key."
  notice "We've already copied the key into the clipboard for you."
  copy_ssh_key
  verify_ssh_auth "github" true
  copy_ssh_key
  verify_ssh_auth "kiln" true
}

verify_ssh_keys
register_ssh_keys
