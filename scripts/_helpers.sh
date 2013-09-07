tty_bold=`tput bold`
tty_normal=`tput sgr0`

notice () {
  printf "         $1\n"
}

info () {
  printf "  [ \033[00;34m..\033[0m ] $1"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1 "
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

warn () {
  printf "\r\033[2K  [\033[0;33mWARN\033[0m] $1\n"
}

error () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
}

install_app () {
  # $1 == full name you would see in /Applications (without .app)
  # $2 == common name (for cask)
  # $3 == what you call it in casual conversation
  info "Checking for $3"
  if [[ -d "$HOME/Applications/$1.app" || -d "/Applications/$1.app" ]]
  then
    success "Great! Found $3"
  else
    success "$3 not found, installing via cask"
    brew cask install $2 > /dev/null
    success "Great, installed $3"
  fi
}
