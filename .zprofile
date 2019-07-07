#!/bin/sh

export LIBVA_DRIVER_NAME=iHD
xbacklight -ctrl tpacpi::kbd_backlight -set 100

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
