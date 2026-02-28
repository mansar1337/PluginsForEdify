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

ui_print "--------------------------------"
ui_print " Device Info"
ui_print "--------------------------------"
ui_print "  Модель    : $(getprop ro.product.model)"
ui_print "  Кодовое имя: $(getprop ro.product.device)"
ui_print "  Android   : $(getprop ro.build.version.release)"
ui_print "  Арх.      : $(getprop ro.product.cpu.abi)"
ui_print "  ROM       : $(getprop ro.build.display.id)"
ui_print "--------------------------------"
exit 0
