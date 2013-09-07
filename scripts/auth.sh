#!/bin/bash

# a slightly improved auth token generator/checker

set -e 

# load helpers for printing info/success/etc
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
      # copy the key
      copy_ssh_key
      # otherwise prompt to upload keys
      notice "\n$service_name ssh auth didn't seem to work, let's add your ssh key"
      notice "\nYour ssh key has already been copied to the clipboard."
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
  verify_ssh_auth "github" true
  verify_ssh_auth "kiln" true
}

setup_vcs_identity(){
  info "Checking if identity set up in .hgrc and .gitconfig"
  if grep -q '%NAME_FIRST_LAST%' "$HOME/.gitconfig" "$HOME/.hgrc" || \
    grep -q '%EMAIL%' "$HOME/.gitconfig" "$HOME/.hgrc"
  then
    success "Hi. Let's set up your .gitconfig and .hgrc with your name"
    introduce_self
  else
    success "Your name is already present in .gitconfig and .hgrc"
  fi
}

introduce_self() {
  confirm="N"
  info "What's your full name?\n"
  user "(e.g. ${tty_bold}First Last$tty_normal):"
  read name
  info "What's your KA username, without @ka.org\n"

  username=`echo $name | awk '{print tolower($1)}'`
  user "(e.g. ${tty_bold}${username}${tty_normal}):"
  read email
  email=${email:-$username}
  info "Commits will be signed like this:\n"
  notice "${tty_bold}${name} <${email}@khanacademy.org>${tty_normal}"

  user "Does this look ok? (yN):"
  read -n1 confirm

  case $confirm in
  y|Y)
    success "Great! updating ~/.gitconfig and ~/.hgrc with your name"
    ;;
  *)
    warn "No problem, let's try that again"
    introduce_self
    ;;
  esac
  perl -pli -e "s/%EMAIL%/$email/g" "$HOME/.gitconfig" "$HOME/.hgrc"
  perl -pli -e "s/%NAME_FIRST_LAST%/$name/g" "$HOME/.gitconfig" "$HOME/.hgrc"
}

setup_vcs_identity
verify_ssh_keys
register_ssh_keys
arc install-certificate

success "Great, it looks like everything is setup!"
notice "You can test that things are working by doing one of the following"
notice "* opening a new terminal window"
notice "* running ${tty_bold}git p${tty_normal} in ~/khan/webapp"
notice "* having a lemonade"
