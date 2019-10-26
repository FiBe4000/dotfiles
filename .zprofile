#!/bin/sh

export XDG_CONFIG_HOME="$HOME/.config"

alias google-chrome-stable="google-chrome-stable --enable-native-gpu-memory-buffers"

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
