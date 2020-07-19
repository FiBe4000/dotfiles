#! /bin/sh

focus_mode=`cat /tmp/bspwmfocusmode.dat`
gaps_only="$1"

if [ "$focus_mode" = false ]; then
  bspc config window_gap 0
  echo "true" > /tmp/bspwmfocusmode.dat
  if [ "$gaps_only" = false ]; then
    ~/.dotfiles/scripts/polybar.sh
  fi
else
  bspc config window_gap 12
  echo "false" > /tmp/bspwmfocusmode.dat
  if [ "$gaps_only" = false ]; then
    ~/.dotfiles/scripts/polybar.sh
  fi
fi
