#!/bin/bash

game_mode=`cat /tmp/game_mode.dat`

leftmonitor=$1
rightmonitor=$2

if [ "$game_mode" = false ]; then
  xrandr --output $rightmonitor --off
  pkill picom
  pkill -USR1 '^redshift$'
  echo "true" > /tmp/game_mode.dat
else
  echo "false" > /tmp/game_mode.dat
  xrandr --output $rightmonitor --right-of $leftmonitor --auto
  picom --config ~/.config/picom/picom.conf -b
  sleep 2
  ~/.dotfiles/scripts/polybar.sh
  ~/.dotfiles/config/bspwm/bspwmrc
fi

