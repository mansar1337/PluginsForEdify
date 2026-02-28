# device_info

Prints device information on the recovery screen.

## updater-script

```edify
package_extract_dir("plugins/device_info", "/tmp/p/device_info");
run_program("/sbin/sh", "/tmp/p/device_info/run.sh", "2");
```

## Output

```
--------------------------------
 Device Info
--------------------------------
  Model     : Mi 9
  Codename  : cepheus
  Android   : 10
  Arch      : arm64-v8a
  ROM       : PKQ1.190302.001
--------------------------------
```
