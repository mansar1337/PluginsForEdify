#!/sbin/sh

# Find the correct output pipe fd
OUTFD=1
for fd in /proc/$$/fd/*; do
    if readlink "$fd" 2>/dev/null | grep -q "^pipe:"; then
        OUTFD="${fd##*/}"
        break
    fi
done
OUTFD=/proc/self/fd/$OUTFD

ui_print() {
    echo -e "ui_print $@" >> "$OUTFD"
    echo -e "ui_print"    >> "$OUTFD"
}

# Read config
. /tmp/p/battery_check/config.prop 2>/dev/null

# Default minimum battery level
MIN_BATTERY="${MIN_BATTERY:-30}"

# Read current battery level
BATTERY=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null)

# Fallback paths
if [ -z "$BATTERY" ]; then
    BATTERY=$(cat /sys/class/power_supply/Battery/capacity 2>/dev/null)
fi

# If still empty — skip check
if [ -z "$BATTERY" ]; then
    ui_print "[WARN] Could not read battery level, skipping check."
    exit 0
fi

ui_print "Battery level: ${BATTERY}%"

if [ "$BATTERY" -ge "$MIN_BATTERY" ]; then
    ui_print "[OK] Battery is sufficient (min: ${MIN_BATTERY}%)"
    exit 0
else
    ui_print "[STOP] Battery too low!"
    ui_print "Current: ${BATTERY}%  Required: ${MIN_BATTERY}%"
    ui_print "Please charge your device and try again."
    exit 1
fi
