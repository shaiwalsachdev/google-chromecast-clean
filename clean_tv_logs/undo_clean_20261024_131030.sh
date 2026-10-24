#!/bin/bash
DEVICE="192.168.1.10:41821"
echo "Reverting Clean TV changes on $DEVICE..."

adb -s "$DEVICE" shell pm enable "com.google.android.federatedcompute"
adb -s "$DEVICE" shell pm enable "com.google.android.ondevicepersonalization.services"
adb -s "$DEVICE" shell pm enable "com.google.android.adservices.api"
adb -s "$DEVICE" shell pm enable "com.google.android.ext.adservices.api"
adb -s "$DEVICE" shell pm enable "com.google.android.sdksandbox"
adb -s "$DEVICE" shell pm enable "com.google.android.feedback"
adb -s "$DEVICE" shell pm enable "com.google.android.partnersetup"
adb -s "$DEVICE" shell pm enable "android.autoinstalls.config.google.gtvpai"
adb -s "$DEVICE" shell pm enable "com.google.android.tv.remotecontrol.logging"
adb -s "$DEVICE" shell pm enable "com.google.android.play.games"
adb -s "$DEVICE" shell pm enable "com.google.android.marvin.talkback"
adb -s "$DEVICE" shell settings put global window_animation_scale 1.0
adb -s "$DEVICE" shell settings put global transition_animation_scale 1.0
adb -s "$DEVICE" shell settings put global animator_duration_scale 1.0
echo "Revert complete! All packages restored and animation scales reset to 1.0."
