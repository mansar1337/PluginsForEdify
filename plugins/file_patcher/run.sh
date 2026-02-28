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
. /tmp/p/file_patcher/config.prop 2>/dev/null

ui_print "File Patcher..."

if [ "$ENABLED" != "true" ]; then
    ui_print "  [skip] ENABLED=false in config.prop"
    exit 0
fi

if [ ! -f "$TARGET" ]; then
    ui_print "  [skip] File not found: $TARGET"
    exit 0
fi

# Backup original file
cp "$TARGET" "${TARGET}.bak"
ui_print "  Backup: ${TARGET}.bak"

# Apply patches
[ -n "$PATCH_1_FROM" ] && sed -i "s|$PATCH_1_FROM|$PATCH_1_TO|g" "$TARGET" && ui_print "  Patch 1 OK"
[ -n "$PATCH_2_FROM" ] && sed -i "s|$PATCH_2_FROM|$PATCH_2_TO|g" "$TARGET" && ui_print "  Patch 2 OK"
[ -n "$PATCH_3_FROM" ] && sed -i "s|$PATCH_3_FROM|$PATCH_3_TO|g" "$TARGET" && ui_print "  Patch 3 OK"

ui_print "  [OK] Patching complete"
exit 0
