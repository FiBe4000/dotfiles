#!/usr/bin/bash

# Terminate already running bar instances
killall -q polybar

# wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

polybar main &

mode=`autorandr --current`

if [ $mode == docked ] || [ $mode == docked_home ]; then
  polybar second &
  polybar third &
fi
