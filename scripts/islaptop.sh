#!/bin/bash

laptop=`cat /tmp/laptop.dat`
if [ "$laptop" = true ]; then
    # For gnome-keyring (used by Evolution)
    eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
    export SSH_AUTH_SOCK

    #xmodmap ~/.dotfiles/other/escremap
    #autorandr --skip-options gamma --change
    #xcalib -o eDP-1 ~/.dotfiles/other/B140QAN02_0.icm
    #xbacklight -ctrl tpacpi::kbd_backlight -set 100
    #libinput-gestures-setup start
fi
