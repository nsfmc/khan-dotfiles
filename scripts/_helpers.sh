tty_bold=`tput bold`
tty_normal=`tput sgr0`

notice () {
  printf "$1\n"
}

info () {
  printf "  [ \033[00;34m..\033[0m ] $1"
}

user () {
  printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

error () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
}