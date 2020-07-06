#!/bin/bash
layout=`setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}'`

if [ $layout == "us" ]; then
  setxkbmap se
  notify-send "Keyboard layout: SE"
else
  setxkbmap us
  notify-send "Keyboard layout: US"
fi
