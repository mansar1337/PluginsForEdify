# file_patcher

Patches system files using `sed` during installation.  
Disabled by default — enable in `config.prop`.

## Config

```properties
ENABLED=true               # set to true to activate
TARGET=/system/build.prop  # file to patch

PATCH_1_FROM=ro.debuggable=0
PATCH_1_TO=ro.debuggable=1

PATCH_2_FROM=persist.sys.usb.config=mtp
PATCH_2_TO=persist.sys.usb.config=mtp,adb
```

## updater-script

```edify
package_extract_dir("plugins/file_patcher", "/tmp/p/file_patcher");
run_program("/sbin/sh", "/tmp/p/file_patcher/run.sh", "2");
```
