# Creating Plugins

## Minimal Plugin

Every plugin needs only one file — `run.sh`.

```
plugins/
└── my_plugin/
    ├── run.sh        ← required
    └── config.prop   ← optional
```

### run.sh template

```sh
#!/sbin/sh

# ── Find pipe fd (copy this block into every plugin) ──────────
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
# ─────────────────────────────────────────────────────────────

# Optional: load config
. /tmp/p/my_plugin/config.prop 2>/dev/null

# Your logic
ui_print "My plugin!"
exit 0
```

---

## Exit Codes

| Code | Effect |
|---|---|
| `exit 0` | Plugin succeeded — installation continues |
| `exit 1` | Plugin failed — **stops install only if using `assert()`** |

---

## updater-script Snippets

### Non-critical plugin (failure = warning only)

```edify
package_extract_dir("plugins/my_plugin", "/tmp/p/my_plugin");
run_program("/sbin/sh", "/tmp/p/my_plugin/run.sh", "2");
```

### Critical plugin (failure = stop installation)

```edify
package_extract_dir("plugins/my_plugin", "/tmp/p/my_plugin");
assert(run_program("/sbin/sh", "/tmp/p/my_plugin/run.sh", "2") == 0);
```

---

## Reading config.prop

```sh
. /tmp/p/my_plugin/config.prop 2>/dev/null
```

Example `config.prop`:

```properties
MY_VALUE=hello
ENABLED=true
```

Access in script:

```sh
ui_print "Value is: $MY_VALUE"
```

---

## Getting Device Properties

```sh
DEVICE=$(getprop ro.product.device)
MODEL=$(getprop ro.product.model)
ANDROID=$(getprop ro.build.version.release)
ARCH=$(getprop ro.product.cpu.abi)
```

---

## Important Notes

- Shell is `mksh` or `ash` in recovery — not `bash`
- Available tools: `busybox`, `sed`, `awk`, `grep`, `getprop`, `cut`, `tr`
- No `source` — use `. file` (POSIX dot)
- Writable paths: `/tmp/`, `/sdcard/` (if mounted)
- `/system` is available after `mount /system` in updater-script
