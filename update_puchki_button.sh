#!/bin/bash
DEVICE="192.168.1.11:45293"

cat << 'JSON_EOF' > my_tv_config.json
{
  "greeting_name": "Shaiwal & Shaila",
  "dock_apps": [
    "com.browsehere.tv",
    "com.netflix.ninja",
    "com.google.android.youtube.tv",
    "in.startv.hotstar",
    "com.amazon.amazonvideo.livingroom",
    "com.sonyliv"
  ],
  "columns": 6,
  "rows_below_dock": 1,
  "dock_glass": true,
  "dock_even_padding": true,
  "ambient_glow": true,
  "background_color": "#0d1117",
  "wallpaper": false
}
JSON_EOF

adb -s "$DEVICE" push my_tv_config.json /sdcard/Android/data/com.gathin.tvhome/files/config.json
echo "Config updated."
