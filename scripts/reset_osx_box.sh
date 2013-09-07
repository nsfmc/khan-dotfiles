#!/bin/bash

set -e

source "_helpers.sh"

warn "removing ssh keys"
rm -f ~/.ssh/id_rsa
rm -f ~/.ssh/id_rsa.pub

warn "removing arcanist pull tmpfile"
rm -f /tmp/arc.pull

warn "clearing viminfo"
rm -f ~/.viminfo

warn "removing .vim/"
rm -rf ~/.vim

warn "removing less history"
rm -f ~/.lesshst

warn "removing bash history"
rm -f ~/.bash_history

warn "restoring .hushlogin"
touch ~/.hushlogin

success "great! close all terminal windows except this one"
info "clear this window's history by hitting option-command-k\n"
info "leave this window open, though\n"
info "reset safari to default, and then\n"
info "back up this laptop with time machine\n"
