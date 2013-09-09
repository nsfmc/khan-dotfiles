#!/bin/bash

set -e

source "_helpers.sh"

warn "resetting identity in .hgrc, .gitconfig"
cp -f ~/.khan-dotfiles/gitconfig.default ~/.gitconfig
cp -f ~/.khan-dotfiles/hgrc.default ~/.hgrc

warn "removing ssh keys"
rm -f ~/.ssh/id_rsa
rm -f ~/.ssh/id_rsa.pub

warn "removing arcanist pull tmpfile"
rm -f /tmp/arc.pull

warn "restoring default .arcrc"
cp -f ~/khan/devtools/arcanist/khan-bin/khan-arcrc ~/.arcrc

warn "clearing viminfo"
rm -f ~/.viminfo

warn "removing .vim/"
rm -rf ~/.vim

warn "removin random ssh seed ~/.rnd"
rm -f ~/.rnd

warn "removing less history"
rm -f ~/.lesshst

warn "removing bash history"
rm -f ~/.bash_history

warn "restoring .hushlogin"
touch ~/.hushlogin

warn "setting up bootstrap script"
touch ~/.bootstrap-ka

success "great! close all terminal windows except this one"
info "clear this window's history by hitting option-command-k\n"
info "leave this window open, though\n"
info "reset safari to default, and then\n"
info "back up this laptop with time machine\n"
