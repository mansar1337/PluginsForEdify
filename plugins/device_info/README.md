# device_info

Prints device information on the recovery screen during installation.

## Output Example

```
--------------------------------
 Device Info
--------------------------------
  Модель    : Mi 9
  Кодовое имя: cepheus
  Android   : 10
  Арх.      : arm64-v8a
  ROM       : PKQ1.190302.001
--------------------------------
```

## updater-script

```edify
package_extract_dir("plugins/device_info", "/tmp/p/device_info");
run_program("/sbin/sh", "/tmp/p/device_info/run.sh", "2");
```
