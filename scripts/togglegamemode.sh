#!/bin/bash

game_mode=`cat /tmp/game_mode.dat`

leftmonitor=$1
rightmonitor=$2
echo $leftmonitor

if [ "$game_mode" = false ]; then
  xrandr --output $leftmonitor --off
  pkill picom
  pkill -USR1 '^redshift$'
  echo "true" > /tmp/game_mode.dat
  sleep 2
  ~/.dotfiles/scripts/polybar.sh
else
  echo "false" > /tmp/game_mode.dat
  xrandr --output $rightmonitor --primary --mode 2560x1440 -r 239.96 --right-of $leftmonitor --output $leftmonitor --mode 2560x1440 -r 144.00
  picom --config ~/.config/picom/picom.conf -b
  sleep 2
  ~/.dotfiles/scripts/polybar.sh
  ~/.dotfiles/config/bspwm/bspwmrc
fi

