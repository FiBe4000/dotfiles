#!/usr/bin/bash

# Terminate already running bar instances
killall -q polybar

# wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

polybar main &

mode=`autorandr --current`
echo $mode

if [[ $mode == "docked" ]] || [[ $mode == "docked_home" ]] || [[ $mode == "docked_home_freesync" ]]; then
  polybar second &
  polybar third &
fi

if [[ $mode == "docked_home_laptop_closed" ]]; then
  polybar second &
fi
