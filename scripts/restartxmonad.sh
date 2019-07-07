#!/bin/sh
killall stalonetray
killall dropbox
xmonad --restart
sleep 2
stalonetray &
dropbox &
