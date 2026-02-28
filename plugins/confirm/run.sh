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
. /tmp/p/confirm/config.prop 2>/dev/null

# Default message
MESSAGE="${MESSAGE:-Do you want to continue installation?}"

ui_print " "
ui_print "==============================="
ui_print " $MESSAGE"
ui_print "==============================="
ui_print "  Vol+  -->  Yes, continue"
ui_print "  Vol-  -->  No, abort"
ui_print " "

# Wait for key press
while true; do
    key=$(getevent -qlc 1 2>/dev/null)

    if [ -z "$key" ]; then
        sleep 0.1
        continue
    fi

    if echo "$key" | grep -q "KEY_VOLUMEUP"; then
        ui_print "[OK] Confirmed! Continuing..."
        ui_print " "
        exit 0
    fi

    if echo "$key" | grep -q "KEY_VOLUMEDOWN"; then
        ui_print "[ABORT] Cancelled by user."
        ui_print " "
        exit 1
    fi
done
