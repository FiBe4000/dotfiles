#!/bin/sh

path=`pwd`

ln -s $path/.bash_profile $HOME/.bash_profile
ln -s $path/.bashrc $HOME/.bashrc
ln -s $path/compton.conf $HOME/.config/compton.conf
ln -s $path/.nvidia-settings-rc $HOME/.nvidia-settings-rc
ln -s $path/.stalonetrayrc $HOME/.stalonetrayrc
ln -s $path/.xinitrc $HOME/.xinitrc
ln -s $path/.xmobarrc $HOME/.xmobarrc
ln -s $path/.Xresources $HOME/.Xresources
ln -s $path/.xserverrc $HOME/.xserverrc
ln -s $path/zathurarc $HOME/.config/zathura/zathurarc
ln -s $path/.zshrc $HOME/.zshrc
sudo ln -s $path/zsh-autosuggestions-config.zsh /usr/share/oh-my-zsh/custom/zsh-autosuggestions-config-zsh
ln -s $path/.zprofile $HOME/.zprofile
