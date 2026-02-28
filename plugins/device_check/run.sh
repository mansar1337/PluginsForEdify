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
. /tmp/p/device_check/config.prop 2>/dev/null

# Get current device codename
DEVICE=$(getprop ro.product.device)
MODEL=$(getprop ro.product.model)

# Skip check if ALLOWED_DEVICES is empty
if [ -z "$ALLOWED_DEVICES" ]; then
    ui_print "[OK] Checking is disabled!"
    exit 0
fi

# Check if device is in the allowed list
MATCHED=false
for allowed in $(echo "$ALLOWED_DEVICES" | tr ',' ' '); do
    if [ "$DEVICE" = "$allowed" ]; then
        MATCHED=true
        break
    fi
done

if [ "$MATCHED" = "true" ]; then
    exit 0
else
    ui_print "[STOP] Incorect device!"
    ui_print "Need: $ALLOWED_DEVICES"
    ui_print "Aborting."
    exit 1
fi
