#!/usr/bin/env bash
set -x

gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'   ;sleep 1
gsettings set org.gnome.desktop.interface icon-theme 'Yaru'       ;sleep 1
gsettings set org.gnome.desktop.interface font-name 'Ubuntu 11'
gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'rgba'

gsettings set org.gnome.desktop.screensaver lock-delay 30
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
gsettings set org.gnome.shell.window-switcher app-icon-mode 'app-icon-only'

gsettings set org.gnome.settings-daemon.plugins.media-keys logout '[]'
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Alt>F11']"
gsettings set org.gnome.desktop.wm.keybindings maximize-vertically "['<Super>w']"
gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true
gsettings set org.gnome.desktop.peripherals.mouse speed 0.375

gsettings set org.gnome.desktop.media-handling automount false
gsettings set org.gnome.desktop.media-handling autorun-never true

gsettings set org.gnome.desktop.privacy recent-files-max-age 30
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy remove-old-trash-files true

gsettings set org.gnome.desktop.interface enable-hot-corners false

dconf write /org/gnome/shell/extensions/dash-to-panel/panel-size 32
dconf write /org/gnome/shell/extensions/dash-to-panel/appicon-padding 2
dconf write /org/gnome/shell/extensions/dash-to-panel/group-apps false
dconf write /org/gnome/shell/extensions/dash-to-panel/isolate-workspaces true
dconf write /org/gnome/shell/extensions/dash-to-panel/show-window-previews false
gsettings set org.gnome.shell enabled-extensions "['dash-to-panel@jderose9.github.com']"