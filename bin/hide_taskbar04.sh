#!/bin/bash

# Auto hide the panel for all users
sed -i 's/edge=top/edge=top\n  autohide=1/' /etc/xdg/lxpanel/LXDE/panels/panel

# Disable the taskbar for all users
sed -i 's@lxpanel --profile LXDE@#lxpanel --profile LXDE@g' /etc/xdg/lxsession/LXDE/autostart

# Restore the taskbar configuration for all users (if needed)
cp -rp /etc/xdg/lxpanel/profile/LXDE/* /etc/xdg/lxpanel/profile/LXDE/
