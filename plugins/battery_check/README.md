# battery_check

Checks battery level before installation.
Stops installation if battery is too low.

## Config

```properties
# Minimum battery level required (percent)
MIN_BATTERY=30
```

## updater-script

```edify
package_extract_dir("plugins/battery_check", "/tmp/p/battery_check");
assert(run_program("/sbin/sh", "/tmp/p/battery_check/run.sh", "2") == 0);
```

## Output

**OK:**
```
Battery level: 75%
[OK] Battery is sufficient (min: 30%)
```

**Too low:**
```
Battery level: 12%
[STOP] Battery too low!
Current: 12%  Required: 30%
Please charge your device and try again.
```
