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
  link_dir $dotfilespath/config/eww/widgets $home/.config/eww/widgets
  link_dir $dotfilespath/config/eww/styles  $home/.config/eww/styles
  # swaync is replaced by notifd + the eww center/popups (see the notifd block
  # below); its config stays in the repo for now, just not installed.
#  sudo -u $user mkdir -p $home/.config/swaync
#  sudo -u $user ln -sfn $dotfilespath/config/swaync/config.json                      $home/.config/swaync/config.json
#  sudo -u $user ln -sfn $dotfilespath/config/swaync/colors.css                       $home/.config/swaync/colors.css
#  sudo -u $user ln -sfn $dotfilespath/config/swaync/style.css                        $home/.config/swaync/style.css
  sudo -u $user ln -sfn $dotfilespath/config/uwsm/env                               $home/.config/uwsm/env

  # environment.d: read by the systemd user manager, so under uwsm these reach
  # the compositor and everything it spawns. Not TTY logins -- zprofile covers
  # SSH_AUTH_SOCK there, and the askpass vars are meant to stay GUI-only.
  sudo -u $user mkdir -p $home/.config/environment.d
  sudo -u $user ln -sfn $dotfilespath/config/environment.d/10-ssh-agent.conf         $home/.config/environment.d/10-ssh-agent.conf
  sudo -u $user ln -sfn $dotfilespath/config/environment.d/20-ssh-askpass.conf       $home/.config/environment.d/20-ssh-askpass.conf
  sudo -u $user mkdir -p $home/.config/gtk-3.0 $home/.config/gtk-4.0
  sudo -u $user ln -sfn $dotfilespath/config/gtk-3.0/settings.ini                    $home/.config/gtk-3.0/settings.ini
  sudo -u $user ln -sfn $dotfilespath/config/gtk-4.0/settings.ini                    $home/.config/gtk-4.0/settings.ini
  # Plasma-only autostart: re-enables kded6's gtkconfig module that hyprland.lua
  # turns off (shared kded5rc). Single link on purpose -- autostart/ holds
  # untracked per-machine entries too, so no link_dir here.
  sudo -u $user mkdir -p $home/.config/autostart
  sudo -u $user ln -sfn $dotfilespath/config/autostart/kded-gtkconfig-enable.desktop $home/.config/autostart/kded-gtkconfig-enable.desktop
  sudo -u $user ln -sfn $dotfilespath/config/xdg-desktop-portal/hyprland-portals.conf $home/.config/xdg-desktop-portal/hyprland-portals.conf

  # Claude Code: settings (hooks feeding the eww bar's session list), status
  # line and hooks. Only these -- the rest of ~/.claude is app state.
  sudo -u $user mkdir -p $home/.claude
  sudo -u $user ln -sfn $dotfilespath/claude/settings.json                           $home/.claude/settings.json
  sudo -u $user ln -sfn $dotfilespath/claude/statusline-command.sh                   $home/.claude/statusline-command.sh
  link_dir $dotfilespath/claude/hooks $home/.claude/hooks

  # /etc/, general
#  ln -sfn $dotfilespath/etc/pacman.conf                                              /etc/pacman.conf
  # PAM stack is copied, not symlinked: an auth config must not be writable from $HOME.
  # Stops hyprlock --grace unlocks from counting as pam_faillock failures.
#  install -m 644 -o root -g root $dotfilespath/etc/pam.d/hyprlock                    /etc/pam.d/hyprlock

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

  # SSH, general. config.d/ holds the work/customer host blocks and is
  # intentionally NOT in this repo -- only create it. Never link_dir anything
  # under ~/.ssh: link_dir rm -rf's its target.
  sudo -u $user mkdir -p $home/.ssh/config.d
  sudo -u $user chmod 700 $home/.ssh $home/.ssh/config.d
  sudo -u $user ln -sfn $dotfilespath/ssh/config                                     $home/.ssh/config

  # systemd user units, general. ssh-agent.socket is openssh's socket-activated
  # agent. plasma-kwallet-pam.service pushes the login-session environment into
  # the ksecretd that pam_kwallet5 started, unlocking kdewallet with the login
  # password -- Plasma pulls the same unit from plasma-workspace.target, so
  # wanting it from graphical-session.target makes it run under Hyprland/uwsm
  # too without double-starting it in Plasma (same unit, one job). Its drop-in
  # delays it until uwsm has imported the login environment and Hyprland is up
  # -- see the comment in 10-after-env.conf; without it the unlock silently does
  # nothing and every app wanting a secret gets a password dialog.
  sudo -u $user mkdir -p $home/.config/systemd/user/sockets.target.wants
  sudo -u $user mkdir -p $home/.config/systemd/user/graphical-session.target.wants
  sudo -u $user mkdir -p $home/.config/systemd/user/plasma-kwallet-pam.service.d
  sudo -u $user ln -sfn /usr/lib/systemd/user/ssh-agent.socket                       $home/.config/systemd/user/sockets.target.wants/ssh-agent.socket
  sudo -u $user ln -sfn /usr/lib/systemd/user/plasma-kwallet-pam.service             $home/.config/systemd/user/graphical-session.target.wants/plasma-kwallet-pam.service
  sudo -u $user ln -sfn $dotfilespath/config/systemd/user/plasma-kwallet-pam.service.d/10-after-env.conf $home/.config/systemd/user/plasma-kwallet-pam.service.d/10-after-env.conf
  # notifd (scripts/notifd) is the notification server for the eww bar/center/
  # popups. The dbus-1 file in ~/.local/share outranks /usr/share's swaync and
  # Plasma activation files and routes activation through the same unit as the
  # hyprland.lua autostart. swaync.service claims the same BusName, so systemd
  # refuses to load notifd.service until it is masked (to go back to swaync:
  # remove that link and the dbus-1 file, restore its autostart line).
  # The eww side (widgets/notifications.yuck, scripts/notif-*, notifd-listen,
  # styles/_notifications.scss) comes in through the eww link_dirs above, and
  # scripts/notifd + scripts/notifctl are run from $HOME/.dotfiles/scripts.
  # Needs: python-gobject, gtk3, gdk-pixbuf2 (notifd); inotify-tools, jq (eww
  # listeners and scripts); wl-clipboard (2FA "Copy" action); systemd's busctl.
  sudo -u $user mkdir -p $home/.local/share/dbus-1/services
  sudo -u $user ln -sfn $dotfilespath/config/systemd/user/notifd.service             $home/.config/systemd/user/notifd.service
  sudo -u $user ln -sfn $dotfilespath/local/share/dbus-1/services/org.freedesktop.Notifications.service $home/.local/share/dbus-1/services/org.freedesktop.Notifications.service
  sudo -u $user ln -sfn /dev/null                                                    $home/.config/systemd/user/swaync.service

  echo "done. Unit and D-Bus service symlinks changed; re-login, or run"
  echo "  systemctl --user daemon-reload"
  echo "  busctl --user call org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus ReloadConfig"
  echo "  systemctl --user start notifd.service"
else
  echo "No changes made to config files."
fi
