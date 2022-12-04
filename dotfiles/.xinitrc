xset r rate 300 50
xrandr --dpi 96

xinput set-float-prop "TPPS/2 IBM TrackPoint" "Device Accel Constant Deceleration" 0.3
xinput set-float-prop "TPPS/2 IBM TrackPoint" "Device Accel Adaptive Deceleration" 1.2
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Timeout" 200
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Axes" 6 7 4 5
xinput set-prop "TPPS/2 IBM TrackPoint" "libinput Accel Speed" 0.95

# Enable core dumps in case something goes wrong
ulimit -c unlimited

# Set up GNOME Keyring
if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
	eval $(dbus-launch --exit-with-session --sh-syntax)
fi
systemctl --user import-environment DISPLAY XAUTHORITY

if command -v dbus-update-activation-environment >/dev/null 2>&1; then
        dbus-update-activation-environment DISPLAY XAUTHORITY
fi

ibus-daemon -drx &

# Ensure user keyring is linked to the session.
keyctl link @u @s
# eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
# export SSH_AUTH_SOCK

exec i3 -V >> ~/.i3/logs/i3log-$(date +'%F-%k-%M-%S') 2>&1
