#!/bin/bash

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
export QT_QPA_PLATFORMTHEME=gtk2
export DESKTOP_SESSION=gnome
export GTK_THEME=Nordic-bluish-accent
export _JAVA_AWT_WM_NONREPARENTING=1
# Cursor size canonical source: config/uwsm/env (Nordic-cursors/16)
export XCURSOR_SIZE=16

exec Hyprland
