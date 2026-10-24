#!/bin/bash
DEVICE="192.168.1.10:41821"
LOG_DIR="clean_tv_logs"
mkdir -p "$LOG_DIR"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
EXEC_LOG="$LOG_DIR/launcher_switch_${TIMESTAMP}.log"

echo "=== Switching to Clean Your TV Launcher: $TIMESTAMP ===" | tee -a "$EXEC_LOG"

# Verify Clean Your TV launcher is installed
if ! adb -s "$DEVICE" shell pm list packages com.gathin.tvhome | grep -q com.gathin.tvhome; then
    echo "Error: com.gathin.tvhome is not installed." | tee -a "$EXEC_LOG"
    exit 1
fi

echo "Disabling stock Google TV launcherx..." | tee -a "$EXEC_LOG"
adb -s "$DEVICE" shell pm disable-user --user 0 com.google.android.apps.tv.launcherx >> "$EXEC_LOG" 2>&1

# Verify new resolution
CURRENT_HOME=$(adb -s "$DEVICE" shell cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME)
echo "Current Home Activity is now: $CURRENT_HOME" | tee -a "$EXEC_LOG"

# Launch Home
adb -s "$DEVICE" shell input keyevent KEYCODE_HOME

# Update undo_latest.sh with launcher restore
cat << 'UNDO_RESTORE' >> undo_latest.sh
echo "Restoring stock Google TV launcherx..."
adb -s "$DEVICE" shell pm enable com.google.android.apps.tv.launcherx
adb -s "$DEVICE" shell input keyevent KEYCODE_HOME
UNDO_RESTORE

echo "=== Launcher Switch Complete! ===" | tee -a "$EXEC_LOG"
