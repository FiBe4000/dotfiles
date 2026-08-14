#!/bin/bash

dotfilespath=`pwd`
user=`logname`
home="/home/$user"

# Determine if running on laptop by looking for battery
battery_path=/sys/class/power_supply/BAT0/capacity
if test -f "$battery_path"; then
  laptop=true
else
  laptop=false
fi

# Symlink a directory, replacing any existing real dir/symlink at the target.
# Plain `ln -sfn` on a directory target that already exists as a real dir drops
# the link *inside* it instead of replacing it, silently deploying stale copies.
# Remove the target first to guarantee a clean replacement.
link_dir() {
  sudo -u $user rm -rf "$2"
  sudo -u $user ln -sfn "$1" "$2"
}

read -p "WARNING! This will overwrite any existing files in the locations. Continue? (y/N) " cont

if [ "$laptop" = true ]; then
  echo "Battery present, assuming laptop"
else
  echo "No battery present, skipping laptop config"
fi

if [ "$cont" = "y" ] || [ "$cont" = "Y" ]; then
  echo "Creating symlinks to config files..."

#  if [ "$laptop" = true ]; then
    # Config in home, laptop
#    sudo -u $user ln -sfn $dotfilespath/config/autorandr                               $home/.config/
#    sudo -u $user ln -sfn $dotfilespath/config/libinputgestures/libinput-gestures.conf $home/.config/libinput-gestures.conf

    # /etc/, laptop
#    ln -sfn $dotfilespath/etc/lenovo_fix.conf                                          /etc/lenovo_fix.conf
#   ln -sfn $dotfilespath/etc/mkinitcpio.conf                                          /etc/mkinitcpio.conf
#   ln -sfn $dotfilespath/etc/tlp.conf                                                 /etc/tlp.conf
#   ln -sfn $dotfilespath/udevrules/backlight.rules                                    /etc/udev/rules.d/backlight.rules
#   ln -sfn $dotfilespath/udevrules/kbd_backlight.rules                                /etc/udev/rules.d/kbd_backlight.rules
#   ln -sfn $dotfilespath/etc/xorg.conf.d/20-modesetting.conf                          /etc/X11/xorg.conf.d/20-modesetting.conf
#   ln -sfn $dotfilespath/etc/xorg.conf.d/30-touchpad.conf                             /etc/X11/xorg.conf.d/30-touchpad.conf
#   ln -sfn $dotfilespath/etc/xorg.conf.d/30-trackpoint.conf                           /etc/X11/xorg.conf.d/30-trackpoint.conf
#   ln -sfn $dotfilespath/etc/xorg.conf.d/90-dvi1.conf                                 /etc/X11/xorg.conf.d/90-dvi1.conf
#   ln -sfn $dotfilespath/etc/xorg.conf.d/90-dvi2.conf                                 /etc/X11/xorg.conf.d/90-dvi2.conf
#   ln -sfn $dotfilespath/etc/xorg.conf.d/90-thinkpadmonitor.conf                      /etc/X11/xorg.conf.d/90-thinkpadmonitor.conf

    # /usr/, laptop
#    ln -sfn $dotfilespath/scripts/keyboard-backlight.sh                                /usr/lib/systemd/system-sleep/keyboard-backlight.sh
#  fi

  # Bash, general
#  sudo -u $user ln -sfn $dotfilespath/bash/bash_profile                              $home/.bash_profile
#  sudo -u $user ln -sfn $dotfilespath/bash/bashrc                                    $home/.bashrc

  # Config in home, general
#  sudo -u $user ln -sfn $dotfilespath/config/bspwm/bspwmrc                           $home/.config/bspwm/bspwmrc
  sudo -u $user ln -sfn $dotfilespath/config/chrome/chrome-flags.conf                $home/.config/chrome-flags.conf
#  sudo -u $user ln -sfn $dotfilespath/config/dunst/dunstrc                           $home/.config/dunst/dunstrc
  sudo -u $user ln -sfn $dotfilespath/config/fontconfig/fonts.conf                   $home/.config/fontconfig/fonts.conf
  sudo -u $user ln -sfn $dotfilespath/config/kitty/kitty.conf                        $home/.config/kitty/kitty.conf
  sudo -u $user ln -sfn $dotfilespath/config/kitty/colors.conf                       $home/.config/kitty/colors.conf
  sudo -u $user ln -sfn $dotfilespath/config/kitty/fonts.conf                        $home/.config/kitty/fonts.conf
#  sudo -u $user ln -sfn $dotfilespath/config/nvim/init.vim                           $home/.config/nvim/init.vim
  sudo -u $user ln -sfn $dotfilespath/config/nvim/init.lua                           $home/.config/nvim/init.lua
#  sudo -u $user ln -sfn $dotfilespath/config/picom/picom.conf                        $home/.config/picom/picom.conf
#  sudo -u $user ln -sfn $dotfilespath/config/polybar/colors                          $home/.config/polybar/colors
#  sudo -u $user ln -sfn $dotfilespath/config/polybar/config                          $home/.config/polybar/config
# sudo -u $user ln -sfn $dotfilespath/config/polybar/fonts                           $home/.config/polybar/fonts
# sudo -u $user ln -sfn $dotfilespath/config/polybar/modules                         $home/.config/polybar/modules
  sudo -u $user ln -sfn $dotfilespath/config/rofi/config.rasi                        $home/.config/rofi/config.rasi
  sudo -u $user ln -sfn $dotfilespath/config/rofi/colors.rasi                        $home/.config/rofi/colors.rasi
  sudo -u $user ln -sfn $dotfilespath/config/rofi/fonts.rasi                         $home/.config/rofi/fonts.rasi
#  sudo -u $user ln -sfn $dotfilespath/config/sxhkd/sxhkdrc                           $home/.config/sxhkd/sxhkdrc
  sudo -u $user ln -sfn $dotfilespath/config/zathura/zathurarc                       $home/.config/zathura/zathurarc

  sudo -u $user ln -sfn $dotfilespath/config/hypr/colors.conf                        $home/.config/hypr/colors.conf
  sudo -u $user ln -sfn $dotfilespath/config/hypr/colors.lua                         $home/.config/hypr/colors.lua
  sudo -u $user ln -sfn $dotfilespath/config/hypr/input.conf                         $home/.config/hypr/input.conf
  sudo -u $user ln -sfn $dotfilespath/config/hypr/input.lua                          $home/.config/hypr/input.lua
  sudo -u $user ln -sfn $dotfilespath/config/hypr/hypridle.conf                      $home/.config/hypr/hypridle.conf
  sudo -u $user ln -sfn $dotfilespath/config/hypr/hyprland.conf                      $home/.config/hypr/hyprland.conf
  sudo -u $user ln -sfn $dotfilespath/config/hypr/hyprland.lua                       $home/.config/hypr/hyprland.lua
  sudo -u $user ln -sfn $dotfilespath/config/hypr/hyprlock.conf                      $home/.config/hypr/hyprlock.conf
  sudo -u $user ln -sfn $dotfilespath/config/hypr/hyprpaper.conf                     $home/.config/hypr/hyprpaper.conf
  sudo -u $user ln -sfn $dotfilespath/config/hypr/monitors.conf                      $home/.config/hypr/monitors.conf
  sudo -u $user ln -sfn $dotfilespath/config/eww/eww.yuck                            $home/.config/eww/eww.yuck
  sudo -u $user ln -sfn $dotfilespath/config/eww/eww.scss                            $home/.config/eww/eww.scss
  sudo -u $user ln -sfn $dotfilespath/config/eww/_colors.scss                        $home/.config/eww/_colors.scss
  sudo -u $user ln -sfn $dotfilespath/config/eww/_fonts.scss                         $home/.config/eww/_fonts.scss
  link_dir $dotfilespath/config/eww/scripts $home/.config/eww/scripts
  sudo -u $user mkdir -p $home/.config/swaync
  sudo -u $user ln -sfn $dotfilespath/config/swaync/config.json                      $home/.config/swaync/config.json
  sudo -u $user ln -sfn $dotfilespath/config/swaync/colors.css                       $home/.config/swaync/colors.css
  sudo -u $user ln -sfn $dotfilespath/config/swaync/style.css                        $home/.config/swaync/style.css
  sudo -u $user ln -sfn $dotfilespath/config/uwsm/env                               $home/.config/uwsm/env
  sudo -u $user mkdir -p $home/.config/gtk-3.0 $home/.config/gtk-4.0
  sudo -u $user ln -sfn $dotfilespath/config/gtk-3.0/settings.ini                    $home/.config/gtk-3.0/settings.ini
  sudo -u $user ln -sfn $dotfilespath/config/gtk-4.0/settings.ini                    $home/.config/gtk-4.0/settings.ini
  sudo -u $user ln -sfn $dotfilespath/config/xdg-desktop-portal/hyprland-portals.conf $home/.config/xdg-desktop-portal/hyprland-portals.conf

  # /etc/, general
#  ln -sfn $dotfilespath/etc/pacman.conf                                              /etc/pacman.conf

  # Local in home, general
#  sudo -u $user ln -sfn $dotfilespath/local/applications/delugeserver.desktop        $home/.local/share/applications/delugeserver.desktop
#  sudo -u $user ln -sfn $dotfilespath/local/applications/facebook-messenger.desktop  $home/.local/share/applications/facebook-messenger.desktop
#  sudo -u $user ln -sfn $dotfilespath/local/applications/google-messages.desktop     $home/.local/share/applications/google-messages.desktop

  # Xorg in home, general
# sudo -u $user ln -sfn $dotfilespath/xorg/xinitrc                                   $home/.xinitrc
# sudo -u $user ln -sfn $dotfilespath/xorg/Xresources                                $home/.Xresources
# sudo -u $user ln -sfn $dotfilespath/xorg/xserverrc                                 $home/.xserverrc

  # Zsh, general
  sudo -u $user ln -sfn $dotfilespath/zsh/zprofile                                   $home/.zprofile
  sudo -u $user ln -sfn $dotfilespath/zsh/zshrc                                      $home/.zshrc
  sudo -u $user ln -sfn $dotfilespath/zsh/colors.zsh                                 $home/.zsh_colors

  echo "done."
else
  echo "No changes made to config files."
fi
