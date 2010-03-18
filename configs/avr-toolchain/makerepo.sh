#!/bin/bash

REPO_ARCH_AVR=/home/arch-avr/os/$(uname -m)

mkdir -p $REPO_ARCH_AVR
mkdir repo
cd repo

# wget http://aur.archlinux.org/packages/nbd/nbd.tar.gz
# tar xf nbd.tar.gz
# cd nbd
# makepkg --asroot
# cp nbd*pkg* $REPO_ARCH_AVR

repo-add $REPO_ARCH_AVR/arch-avr.db.tar.gz $REPO_ARCH_AVR/*pkg*
