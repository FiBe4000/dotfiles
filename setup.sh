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
ln -s $path/fibe_dotfiles_stalonetrayrc.base $HOME/.config/wpg/templates/fibe_dotfiles_stalonetrayrc.base
ln -s $path/fibe_dotfiles_xmobarrc.base $HOME/.config/wpg/templates/fibe_dotfiles_xmobarrc.base
ln -s $path/fibe_xmonad_xmonad.hs.base $HOME/.config/wpg/templates/fibe_xmonad_xmonad.hs.base
ln -s $path/gtk2.base $HOME/.config/wpg/templates/gtk2.base
ln -s $path/gtk3.0.base $HOME/.config/wpg/templates/gtk3.0.base
ln -s $path/gtk3.20.base $HOME/.config/wpg/templates/gtk3.20.base
ln -0 $path/rofi.base $HOME/.config/wpg/templates/rofi.base
ln -0 $path/wpg.conf $HOME/.config/wpg/wpg.conf
sudo ln -s $path/zsh-autosuggestions-config.zsh /usr/share/oh-my-zsh/custom/zsh-autosuggestions-config-zsh
ln -s $path/.zprofile $HOME/.zprofile
