#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xsetroot -cursor_name left_ptr
setxkbmap us
#xmodmap ~/.dotfiles/.escremap
compton --config ~/.config/compton.conf -b
#stalonetray &
nm-applet &
blueman-applet &
#xss-lock -- sflock -f "-misc-fixed-medium-r-semicondensed--13-120-75-75-c-60-iso8859-1" &
dropbox &
#/home/fibe/.xmonad/scripts/setwallpaper.sh
wpg -m
udiskie &
urxvtd -q -f -o
sxhkd &
exec bspwm
