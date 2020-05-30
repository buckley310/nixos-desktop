#!/usr/bin/env bash
set -x

dconf write /org/gnome/shell/extensions/dash-to-panel/panel-size 32
dconf write /org/gnome/shell/extensions/dash-to-panel/appicon-padding 2
dconf write /org/gnome/shell/extensions/dash-to-panel/group-apps false
dconf write /org/gnome/shell/extensions/dash-to-panel/isolate-workspaces true
dconf write /org/gnome/shell/extensions/dash-to-panel/show-window-previews false
dconf write /org/gnome/shell/extensions/dash-to-panel/show-showdesktop-button false
