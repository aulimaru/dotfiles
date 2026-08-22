#!/usr/bin/env sh

keepassxc &
sleep 1
hyprctl dispatch movetoworkspacesilent 10,class:org.keepassxc.KeePassXC
