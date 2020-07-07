#!/bin/bash

dotfilespath=`pwd`
user=`logname`
home="/home/$user"

read -p "WARNING! This will overwrite any existing files in the locations. Continue? (y/N) " cont
read -p "Do you want to install the FiBe4000 Vim config? (y/N) " wantvim

if [ "$cont" = "y" ] || [ "$cont" = "Y" ]; then
  echo "Creating symlinks to config files..."

  # Bash
  sudo -u $user ln -sfn $dotfilespath/bash/bash_profile                              $home/.bash_profile
  sudo -u $user ln -sfn $dotfilespath/bash/bashrc                                    $home/.bashrc

  # Config in home
  sudo -u $user ln -sfn $dotfilespath/config/autorandr                               $home/.config/
  sudo -u $user ln -sfn $dotfilespath/config/bspwm/bspwmrc                           $home/.config/bspwm/bspwmrc
  sudo -u $user ln -sfn $dotfilespath/config/chrome/chrome-flags.conf                $home/.config/chrome-flags.conf
  sudo -u $user ln -sfn $dotfilespath/config/compton/compton.conf                    $home/.config/compton.conf
  sudo -u $user ln -sfn $dotfilespath/config/dunst/dunstrc                           $home/.config/dunst/dunstrc
  sudo -u $user ln -sfn $dotfilespath/config/fontconfig/fonts.conf                   $home/.config/fontconfig/fonts.conf
  sudo -u $user ln -sfn $dotfilespath/config/kitty/kitty.conf                        $home/.config/kitty/kitty.conf
  sudo -u $user ln -sfn $dotfilespath/config/kitty/nord.conf                         $home/.config/kitty/nord.conf
  sudo -u $user ln -sfn $dotfilespath/config/libinputgestures/libinput-gestures.conf $home/.config/libinput-gestures.conf
  sudo -u $user ln -sfn $dotfilespath/config/polybar/config                          $home/.config/polybar/config
  sudo -u $user ln -sfn $dotfilespath/config/rofi/config                             $home/.config/rofi/config
  sudo -u $user ln -sfn $dotfilespath/config/sxhkd/sxhkdrc                           $home/.config/sxhkd/sxhkdrc
  sudo -u $user ln -sfn $dotfilespath/config/zathura/zathurarc                       $home/.config/zathura/zathurarc

  # /etc/
  ln -sfn $dotfilespath/etc/lenovo_fix.conf                                          /etc/lenovo_fix.conf
  ln -sfn $dotfilespath/etc/mkinitcpio.conf                                          /etc/mkinitcpio.conf
  ln -sfn $dotfilespath/etc/tlp.conf                                                 /etc/tlp.conf
  ln -sfn $dotfilespath/udevrules/backlight.rules                                    /etc/udev/rules.d/backlight.rules
  ln -sfn $dotfilespath/udevrules/kbd_backlight.rules                                /etc/udev/rules.d/kbd_backlight.rules
  ln -sfn $dotfilespath/xorg.conf.d/20-modesetting.conf                              /etc/X11/xorg.conf.d/20-modesetting.conf
  ln -sfn $dotfilespath/xorg.conf.d/30-touchpad.conf                                 /etc/X11/xorg.conf.d/30-touchpad.conf
  ln -sfn $dotfilespath/xorg.conf.d/90-dvi1.conf                                     /etc/X11/xorg.conf.d/90-dvi1.conf
  ln -sfn $dotfilespath/xorg.conf.d/90-dvi2.conf                                     /etc/X11/xorg.conf.d/90-dvi2.conf
  ln -sfn $dotfilespath/xorg.conf.d/90-thinkpadmonitor.conf                          /etc/X11/xorg.conf.d/90-thinkpadmonitor.conf

  # Local in home
  sudo -u $user ln -sfn $dotfilespath/local/applications/delugeserver.desktop        $home/.local/share/applications/delugeserver.desktop
  sudo -u $user ln -sfn $dotfilespath/local/applications/facebook-messenger.desktop  $home/.local/share/applications/facebook-messenger.desktop
  sudo -u $user ln -sfn $dotfilespath/local/applications/google-messages.desktop     $home/.local/share/applications/google-messages.desktop

  # /usr/
  ln -sfn $dotfilespath/usr/libinput/local-overrides.quirks                          /usr/share/libinput/local-overrides.quirks
  ln -sfn $dotfilespath/scripts/keyboard-backlight.sh                                /usr/lib/systemd/system-sleep/keyboard-backlight.sh

  # Xorg in home
  sudo -u $user ln -sfn $dotfilespath/xorg/xinitrc                                   $home/.xinitrc
  sudo -u $user ln -sfn $dotfilespath/xorg/Xresources                                $home/.Xresources
  sudo -u $user ln -sfn $dotfilespath/xorg/xserverrc                                 $home/.xserverrc

  # Zsh
  sudo -u $user ln -sfn $dotfilespath/zsh/zprofile                                   $home/.zprofile
  sudo -u $user ln -sfn $dotfilespath/zsh/zshrc                                      $home/.zshrc
  echo "done."
else
  echo "No changes made to config files."
fi

if [ "$wantvim" = "y" ] || [ "$wantvim" = "Y" ]; then
  echo "Retrieving git submodule for FiBe4000 Vim config..."
  git submodule init
  git submodule update
  echo "done."
  cd vim
  $dotfilespath/vim/setup.sh
  cd ..
else
  echo "FiBe4000 Vim config not installed."
fi
