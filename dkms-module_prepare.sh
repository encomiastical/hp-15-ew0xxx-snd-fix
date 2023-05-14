#!/bin/sh

# make the script stop on error
set -e

pacman -S pahole dkms base-devel linux-headers

# see https://askubuntu.com/questions/1348250/skipping-btf-generation-xxx-due-to-unavailability-of-vmlinux-on-ubuntu-21-04
sudo cp /sys/kernel/btf/vmlinux "/usr/lib/modules/$(uname -r)/build/"
