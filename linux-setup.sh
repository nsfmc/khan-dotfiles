#!/bin/sh

# This installs binaries that you need to develop at Khan Academy.
# The OS-independent setup.sh assumes all this stuff has been
# installed.

# Bail on any errors
set -e


install_packages() {
    updated_apt_repo=""

    # native hipchat client (BETA, x86/x86_64 only)
    if ! grep -q 'downloads.hipchat.com' /etc/apt/sources.list; then
        sudo add-apt-repository -y \
            "deb http://downloads.hipchat.com/linux/apt stable main" 
        wget -O- https://www.hipchat.com/keys/hipchat-linux.key \
            | sudo apt-key add -
        updated_apt_repo=yes
    fi

    # To get the most recent nodejs, later.
    if ! ls /etc/apt/sources.list.d/ 2>&1 | grep -q chris-lea-node_js; then
        sudo add-apt-repository -y ppa:chris-lea/node.js
        updated_apt_repo=yes
    fi

    # To get the most recent git.
    if ! ls /etc/apt/sources.list.d/ 2>&1 | grep -q git-core-ppa; then
        sudo add-apt-repository -y ppa:git-core/ppa
        updated_apt_repo=yes
    fi

    # Register all that stuff we just did.
    if [ -n "$updated_apt_repo" ]; then
        sudo apt-get update -qq -y || true
    fi

    # Needed to develop at Khan: git and mercurial, python, ruby, node (js).
    # xslt and xml are needed by the nokogiri ruby package.
    sudo apt-get install -y git git-svn mercurial \
        pychecker python-mode python-setuptools python-pip python-virtualenv \
        ruby ruby-dev rubygems libxslt-dev libxml2-dev \
        nodejs

    # Not technically needed to develop at Khan, but we assume you have it.
    sudo apt-get install -y nginx unrar virtualbox ack-grep

    # Not needed for Khan, but useful things to have.
    sudo apt-get install -y ntp abiword curl diffstat expect gimp \
        imagemagick mplayer netcat netpbm screen w3m vim 

    # If you don't have the other ack installed, ack is shorter than ack-grep
    sudo dpkg-divert --local --divert /usr/bin/ack --rename --add \
        /usr/bin/ack-grep  

    # Native hipchat client (BETA, x86/x86_64 only).  
    sudo apt-get install -y hipchat

    # Needed for the AIR-based hipchat client on linux, not needed if
    # you use the native client.
    # sudo apt-get install -y adobeair

    # Needed to install printer drivers, and to use the printer scanner
    sudo apt-get install -y apparmor-utils xsane
}

setup_clock() {
    # This shouldn't be necessary, but it seems it is.
    if ! grep -q 3.ubuntu.pool.ntp.org /etc/ntp.conf; then
        sudo service ntp stop
        sudo ntpdate 0.ubuntu.pool.ntp.org 1.ubuntu.pool.ntp.org \
            2.ubuntu.pool.ntp.org 3.ubuntu.pool.ntp.org
        sudo service ntp start
    fi
}


# Run sudo once at the beginning to get the necessary permissions.
echo "This setup script needs your password to install things as root."
sudo sh -c 'echo Thanks'

install_packages
setup_clock
