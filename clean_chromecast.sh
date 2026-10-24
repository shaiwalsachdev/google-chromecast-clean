#!/bin/bash

DEVICE="192.168.1.10:41821"
LOG_DIR="clean_tv_logs"
mkdir -p "$LOG_DIR"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
EXEC_LOG="$LOG_DIR/execution_${TIMESTAMP}.log"
UNDO_SCRIPT="$LOG_DIR/undo_clean_${TIMESTAMP}.sh"
LATEST_UNDO="undo_latest.sh"

echo "=== Clean TV Optimization Run: $TIMESTAMP ===" | tee -a "$EXEC_LOG"

# Generate undo header
cat << 'UNDO_EOF' > "$UNDO_SCRIPT"
#!/bin/bash
DEVICE="192.168.1.10:41821"
echo "Reverting Clean TV changes on $DEVICE..."

UNDO_EOF

# Function to safely disable a package and register undo
disable_pkg() {
    PKG=$1
    DESC=$2
    echo "Processing [$PKG] ($DESC)..." | tee -a "$EXEC_LOG"
    if adb -s "$DEVICE" shell pm list packages "$PKG" | grep -q "$PKG"; then
        RES=$(adb -s "$DEVICE" shell pm disable-user --user 0 "$PKG" 2>&1)
        if echo "$RES" | grep -q "disabled-user"; then
            echo "adb -s \"\$DEVICE\" shell pm enable \"$PKG\"" >> "$UNDO_SCRIPT"
            echo "  -> Successfully disabled: $PKG" | tee -a "$EXEC_LOG"
        else
            echo "  -> Protected by system, skipped ($RES)" | tee -a "$EXEC_LOG"
        fi
    else
        echo "  -> Skipped (not installed): $PKG" | tee -a "$EXEC_LOG"
    fi
}

# 1. Privacy Sandbox / Ads / Telemetry
echo "--- Step 1: Disabling Telemetry & Ad Services ---" | tee -a "$EXEC_LOG"
disable_pkg "com.google.android.federatedcompute" "Federated compute background telemetry"
disable_pkg "com.google.android.ondevicepersonalization.services" "On-device personalization ads/tracking"
disable_pkg "com.google.android.adservices.api" "Android AdServices API"
disable_pkg "com.google.android.ext.adservices.api" "AdServices extension module"
disable_pkg "com.google.android.sdksandbox" "SDK Sandbox ad runtime"
disable_pkg "com.google.android.feedback" "Google user feedback daemon"
disable_pkg "com.google.android.partnersetup" "Partner telemetry setup"
disable_pkg "com.google.android.tvrecommendations" "Home recommendation ads injector"
disable_pkg "android.autoinstalls.config.google.gtvpai" "Partner auto-installs"
disable_pkg "com.google.android.tv.remotecontrol.logging" "Remote control analytics logging"

# 2. Unused Preloaded Bloat
echo "--- Step 2: Disabling Unused Google Preloads ---" | tee -a "$EXEC_LOG"
disable_pkg "com.google.android.play.games" "Google Play Games TV background daemon"
disable_pkg "com.google.android.apps.education.cast2class" "Google Cast for Education / Classroom"
disable_pkg "com.google.android.marvin.talkback" "TalkBack Screen Reader (accessibility)"

# 3. Optimize UI Speed / Animation Scales (0.5x speed multiplier = 2x snappier UI)
echo "--- Step 3: Accelerating UI Animation Speeds ---" | tee -a "$EXEC_LOG"
adb -s "$DEVICE" shell settings put global window_animation_scale 0.5 >> "$EXEC_LOG" 2>&1
adb -s "$DEVICE" shell settings put global transition_animation_scale 0.5 >> "$EXEC_LOG" 2>&1
adb -s "$DEVICE" shell settings put global animator_duration_scale 0.5 >> "$EXEC_LOG" 2>&1

echo "adb -s \"\$DEVICE\" shell settings put global window_animation_scale 1.0" >> "$UNDO_SCRIPT"
echo "adb -s \"\$DEVICE\" shell settings put global transition_animation_scale 1.0" >> "$UNDO_SCRIPT"
echo "adb -s \"\$DEVICE\" shell settings put global animator_duration_scale 1.0" >> "$UNDO_SCRIPT"
echo "  -> Animation scales set to 0.5x (snappy & responsive)" | tee -a "$EXEC_LOG"

# Complete undo script
cat << 'UNDO_EOF' >> "$UNDO_SCRIPT"
echo "Revert complete! All packages restored and animation scales reset to 1.0."
UNDO_EOF

chmod +x "$UNDO_SCRIPT"
cp "$UNDO_SCRIPT" "$LATEST_UNDO"
chmod +x "$LATEST_UNDO"

echo "=== Optimization Completed Successfully! ===" | tee -a "$EXEC_LOG"
echo "Detailed log: $EXEC_LOG" | tee -a "$EXEC_LOG"
echo "Undo script created: $UNDO_SCRIPT (and linked to $LATEST_UNDO)" | tee -a "$EXEC_LOG"
