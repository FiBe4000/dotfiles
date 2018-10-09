#!/bin/sh

path=`pwd`

ln -s $path/.bash_profile $HOME/.bash_profile
ln -s $path/.bashrc $HOME/.bashrc
ln -s $path/.xinitrc $HOME/.xinitrc
ln -s $path/.Xresources $HOME/.Xresources
ln -s $path/.xserverrc $HOME/.xserverrc
ln -s $path/zathurarc $HOME/.config/zathura/zathurarc
