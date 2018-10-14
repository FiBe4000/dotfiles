#!/bin/sh

path=`pwd`

sudo ln -s $path/20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf
sudo ln -s $path/30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf
ln -s $path/.bash_profile $HOME/.bash_profile
ln -s $path/.bashrc $HOME/.bashrc
ln -s $path/.stalonetrayrc $HOME/.stalonetrayrc
ln -s $path/.xinitrc $HOME/.xinitrc
ln -s $path/.xmobarrc $HOME/.xmobarrc
ln -s $path/.Xresources $HOME/.Xresources
ln -s $path/.xserverrc $HOME/.xserverrc
ln -s $path/libinput-gestures.conf $HOME/.config/libinput-gestures.conf
sudo ln -s $path/tlp /etc/default/tlp
ln -s $path/zathurarc $HOME/.config/zathura/zathurarc
