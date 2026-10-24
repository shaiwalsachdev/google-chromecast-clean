#!/bin/bash
# SAFE SETUP: Installs custom launcher and configures button mapper ONLY.
# DOES NOT DISABLE OR TOUCH ANY SYSTEM SERVICES, PACKAGES, OR OS DAEMONS.

DEVICE=${1:-"192.168.1.10:5555"}
echo "Using target device: $DEVICE"

# 1. Install custom Clean Your TV launcher
echo "Installing Clean Your TV Launcher..."
adb -s "$DEVICE" install -r ./android/platform/src/main/assets/bundled/cleanyourtv-launcher.apk

# 2. Push personalized couple profile (Shaiwal & Shaila)
echo "Applying personalized Shaiwal & Shaila configuration..."
adb -s "$DEVICE" shell mkdir -p /sdcard/Android/data/com.gathin.tvhome/files/
adb -s "$DEVICE" push my_tv_config.json /sdcard/Android/data/com.gathin.tvhome/files/config.json

echo "=== Setup complete! Zero system services modified ==="
