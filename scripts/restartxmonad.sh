#!/bin/sh
killall stalonetray
killall dropbox
xmonad --restart
stalonetray &
dropbox &
