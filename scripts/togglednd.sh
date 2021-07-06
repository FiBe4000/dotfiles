#!/bin/bash

dnd=`cat /tmp/dnd.dat`
laptop=`cat /tmp/laptop.dat`

if [ $dnd == "false" ]; then
  if [ $laptop = "true" ]; then
    polybar dnd2 &
  else
    polybar dnd &
  fi
  echo "true" > /tmp/dnd.dat
  notify-send -i dialog-error "Do not disturb on"
  sleep 5
  dunstctl set-paused true
else
  pkill -f "polybar dnd" &
  echo "false" > /tmp/dnd.dat
  dunstctl set-paused false
  notify-send "Do not disturb off"
fi
