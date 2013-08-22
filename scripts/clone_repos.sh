#!/bin/bash

# This clones all the repos most ka-devs need. 
# 
# $1 WEBAPP (defaults to $HOME/khan)
# $2 DEVTOOLS (defaults to $HOME/khan/devtools)

# In order, it does:
#   1. checks to see if your ssh keys for kiln work
#   2. creates $WEBAPP/webapp (for the webapp)
#   3. creates $DEVTOOLS/kiln-review
#   4. creates $DEVTOOLS/khan-linter
#   5. creates $DEVTOOLS/libphutil
#   6. creates $DEVTOOLS/arcanist

# Bail on any errors
set -e

# load helpers for printing info/success/etc
source "_helpers.sh"

# Install in $HOME by default, but can set an alternate destination via $1.
DEFAULT_WEBAPP="$HOME/khan"
WEBAPP=${1-$DEFAULT_WEBAPP}
mkdir -p "$WEBAPP"

DEFAULT_DEVTOOLS="$WEBAPP/devtools"
DEVTOOLS=${2-$DEFAULT_DEVTOOLS}
mkdir -p "$DEVTOOLS"

# $1: url of the repository to clone.  $2: directory to put repo, under $ROOT
git_clone() {
  (
    mkdir -p "$2"
    cd "$2"
    dirname=`basename "$1"`
    if [ ! -d "$dirname" ]; then
      git clone "$1"
      cd `basename $1`
      git submodule update --init --recursive
    else
      cd `basename $1`
      # This 'git init' installs any new hooks we may have created.
      git init -q
    fi
  )
}

get_kiln_hg_extensions () {
  get_hgexts=false

  user "Will you be using hg? [yn]"
  read -n 1 kilnplease

  case "$kilnplease" in 
    y )
      get_hgexts=true;;
    Y )
      get_hgexts=true;;
    * )
      ;;
  esac

  if [ "$get_hgexts" == "true" ]
  then
    success "cool, installing hg extensions"
    # For hg users
    (
      cd $DEVTOOLS
      hg clone https://bitbucket.org/brendan/mercurial-extensions-rdiff || true

      mkdir -p kiln_extensions
      if [ ! -e kiln_extensions/kilnauth.py ]
      then
        curl -s https://khanacademy.kilnhg.com/Tools/Downloads/Extensions \
          > /tmp/extensions.zip \
          && unzip -qo /tmp/extensions.zip kiln_extensions/kilnauth.py
        success "Kiln hg extensions installed."
      fi
    )
  else
    success "OK, skipping kiln hg extensions"
  fi
}

verify_hg () {
  if ! test $(which hg)
  then
    error "hg not installed, run (. scripts/vcs.sh)"
    exit 1
  fi
}

# checks to see that ssh keys are registered with kiln
verify_kiln_auth () {
  info "Checking for kiln auth"
  if ! ssh -T -v khanacademy@khanacademy.kilnhg.com 2>&1 >/dev/null | grep \
    -q -e "Authentication succeeded (publickey)"
  then
    error "Please Set Up Your Kiln SSH Keys (. scripts/auth.sh)\n"
    exit 1
  fi
  success "ssh kiln auth looks good!"
}

# clones the main app repositories as git repos
clone_repos () {
  notice "I'm about the webapp into $WEBAPP"
  notice "  (this takes a while)"
  git_clone ssh://khanacademy@khanacademy.kilnhg.com/Website/Group/webapp \
    $WEBAPP
  notice "Cloning kiln-review into"
  git_clone git@github.com:Khan/kiln-review $DEVTOOLS
  notice "Cloning khan-linter"
  git_clone git@github.com:Khan/khan-linter $DEVTOOLS
  notice "Cloning libphutil (for phabricator)"
  git_clone git@github.com:Khan/libphutil $DEVTOOLS
  notice "Cloning arcanist, for phabricator (last one, i promise)"
  git_clone git@github.com:Khan/arcanist $DEVTOOLS
}


verify_hg
get_kiln_hg_extensions
verify_kiln_auth
clone_repos
