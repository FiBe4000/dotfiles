#!/usr/bin/bash

# Get status of focus mode
focus_mode=`cat /tmp/bspwmfocusmode.dat`

# Terminate already running bar instances
killall -q polybar

# wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

if [ "$focus_mode" = false ]; then
  polybar main &
else
  polybar focused_main &
fi

mode=`autorandr --current`
echo $mode

if [[ $mode == "docked" ]] || [[ $mode == "docked_home" ]] || [[ $mode == "docked_home_freesync" ]]; then
  if [ "$focus_mode" = false ]; then
    polybar second &
    polybar third &
  else
    polybar focused_second &
    polybar focused_third &
  fi
fi

if [[ $mode == "docked_home_laptop_closed" ]]; then
  if [ "$focus_mode" = false ]; then
    polybar second &
  else
    polybar focused_second &
  fi
fi
