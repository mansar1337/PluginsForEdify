# Plugins For Edify

A modular plugin system for Android firmware ZIP packages (TWRP / Recovery).
Write shell scripts that run during installation — check devices, check battery, confirm actions, patch files, and more.

---

## How It Works

During installation, `updater-script` extracts each plugin folder to `/tmp/p/` and runs it via `run_program`.
Each plugin is a standalone `run.sh` with an optional `config.prop`.

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
    └── ...
```

---

## Quick Start

### 1. Copy plugin folder into your ZIP

```
plugins/
└── device_check/
    ├── run.sh
    └── config.prop
```

### 2. Add to `updater-script`

```edify
package_extract_dir("plugins/device_check", "/tmp/p/device_check");
assert(run_program("/sbin/sh", "/tmp/p/device_check/run.sh", "2") == 0);
```

> Use `assert()` if the plugin must be able to stop installation on failure.
> Use `run_program()` alone if failure is non-critical.

---

## Available Plugins

| Plugin | Description |
|---|---|
| [device_check](plugins/device_check/) | Check device codename — stops installation if wrong device |
| [battery_check](plugins/battery_check/) | Check battery level — stops installation if too low |
| [confirm](plugins/confirm/) | Ask user to confirm via Vol+ / Vol- before continuing |
| [device_info](plugins/device_info/) | Print device model, codename, Android version, arch |
| [file_patcher](plugins/file_patcher/) | Patch system files using sed (e.g. build.prop) |
| [hello_world](plugins/hello_world/) | Minimal example plugin — use as a template |

---

## Writing Your Own Plugin

Every plugin needs only one file — `run.sh`:

```sh
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

# Your logic here
ui_print "Hello from my plugin!"
exit 0
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
- Xiaomi Mi 9 (`cepheus`)
- update-binary: AOSP standard

---

## Contributing

Feel free to open a PR with new plugins or fixes.
Each plugin lives in its own folder under `plugins/` with a `run.sh`, optional `config.prop`, and `README.md`.

---

## License

MIT — see [LICENSE](LICENSE)
