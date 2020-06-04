#!/usr/bin/env bash
set -x

gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark';sleep 1
gsettings set org.gnome.desktop.interface icon-theme 'Numix';sleep 1
gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'rgba'
gsettings set org.gnome.settings-daemon.plugins.xsettings hinting 'full'

gsettings set org.gnome.desktop.screensaver lock-delay 30
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.notifications show-in-lock-screen false

gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"

gsettings set org.gnome.settings-daemon.plugins.media-keys logout '[]'
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Primary><Shift><Alt>f']"
gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true
gsettings set org.gnome.desktop.peripherals.mouse speed 0.375

gsettings set org.gnome.desktop.media-handling automount false
gsettings set org.gnome.desktop.media-handling autorun-never true

gsettings set org.gnome.desktop.privacy recent-files-max-age 30
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy remove-old-trash-files true

gsettings set org.gnome.desktop.interface enable-hot-corners false
