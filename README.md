# Plugins For Edify

A modular plugin system for Android firmware ZIP packages (TWRP / Recovery).  
Write shell scripts that run during installation — check devices, patch files, show info, and more.

---

## How It Works

During installation, `updater-script` extracts each plugin folder to `/tmp/p/` and runs it via `run_program`.  
Every plugin is a standalone `run.sh` script with its own `config.prop`.

```
firmware.zip
├── META-INF/
│   └── com/google/android/
│       ├── updater-script     ← lists plugins to run
│       └── update-binary      ← EDIFY engine
└── plugins/
    ├── device_check/
    │   ├── run.sh
    │   └── config.prop
    ├── device_info/
    │   └── run.sh
    ├── hello_world/
    │   └── run.sh
    └── file_patcher/
        ├── run.sh
        └── config.prop
```

---

## Quick Start

### 1. Add a plugin to your ZIP

```bash
# Copy plugin folder into your project
cp -r plugins/device_check my_firmware/plugins/

# Add to updater-script (see below)
# Pack the ZIP
zip -r firmware.zip META-INF/ plugins/
```

### 2. Add to `updater-script`

```edify
package_extract_dir("plugins/device_check", "/tmp/p/device_check");
assert(run_program("/sbin/sh", "/tmp/p/device_check/run.sh", "2") == 0);
```

> Use `assert()` if the plugin must stop installation on failure.  
> Use `run_program()` alone if failure is non-critical.

---

## Available Plugins

| Plugin | Description |
|---|---|
| [device_check](plugins/device_check/) | Checks device codename — stops installation if wrong device |
| [device_info](plugins/device_info/) | Prints device model, codename, Android version, architecture |
| [hello_world](plugins/hello_world/) | Minimal example plugin |
| [file_patcher](plugins/file_patcher/) | Patches system files using `sed` (e.g. `build.prop`) |

---

## Writing Your Own Plugin

Every plugin needs only one file — `run.sh`:

```sh
#!/sbin/sh

# Find the correct output pipe fd (required for TWRP screen output)
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

# Your logic here
ui_print "Hello from my plugin!"
exit 0
```

Then add it to `updater-script`:

```edify
package_extract_dir("plugins/my_plugin", "/tmp/p/my_plugin");
run_program("/sbin/sh", "/tmp/p/my_plugin/run.sh", "2");
```

See [docs/creating-plugins.md](docs/creating-plugins.md) for full guide.

---

## Exit Codes

| Code | Meaning |
|---|---|
| `exit 0` | Success — continue installation |
| `exit 1` | Failure — stops installation **only if wrapped in `assert()`** |

---

## Tested On

- TWRP 3.x (Android 10+)
- Xiaomi Mi 9 (`cepheus`) — Android 99.87.36
- update-binary: AOSP standard (`updater_main.cpp`)

---

## License

MIT — see [LICENSE](LICENSE)
