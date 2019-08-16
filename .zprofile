#!/bin/sh

export LIBVA_DRIVER_NAME=iHD
export XDG_CONFIG_HOME="$HOME/.config"

[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1 &> /dev/null
xbacklight -ctrl tpacpi::kbd_backlight -set 100

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
