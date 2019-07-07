#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# Fix scaling

export GDK_SCALE=1
export GDK_DPI_SCALE=0.5
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR=1

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
setxkbmap se
xmodmap ~/.dotfiles/.escremap
xbacklight -ctrl tpacpi::kbd_backlight -set 100
compton --config ~/.config/compton.conf -b
stalonetray &
#trayer --monitor primary --edge top --align right --widthtype percent --width 5 --height 24 &
nm-applet &
blueman-applet &
xss-lock -- sxlock -f "-misc-fixed-medium-r-semicondensed--13-120-75-75-c-60-iso8859-1" &
dropbox &
#/home/fibe/.xmonad/scripts/setwallpaper.sh
wpg -m
udiskie &
libinput-gestures-setup start
urxvtd -q -f -o
exec xmonad
