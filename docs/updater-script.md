# updater-script Reference

## Full Example

```edify
# ── Device check (stops installation on wrong device) ────────
package_extract_dir("plugins/device_check", "/tmp/p/device_check");
assert(run_program("/sbin/sh", "/tmp/p/device_check/run.sh", "2") == 0);

# ── Info (non-critical) ──────────────────────────────────────
package_extract_dir("plugins/device_info", "/tmp/p/device_info");
run_program("/sbin/sh", "/tmp/p/device_info/run.sh", "2");

# ── Main installation ────────────────────────────────────────
ui_print("Installing system...");
mount("ext4", "EMMC", "/dev/block/bootdevice/by-name/system", "/system");
package_extract_dir("system", "/system");

# ── Post-install patch ───────────────────────────────────────
package_extract_dir("plugins/file_patcher", "/tmp/p/file_patcher");
run_program("/sbin/sh", "/tmp/p/file_patcher/run.sh", "2");

ui_print("Done!");
```

---

## Key Functions

| Function | Description |
|---|---|
| `ui_print("text")` | Print text on recovery screen |
| `package_extract_dir("src", "dst")` | Extract folder from ZIP to path |
| `run_program("bin", arg1, arg2...)` | Run a program, returns exit code |
| `assert(expr)` | Stop installation if expr is false |
| `mount(fs, type, device, path)` | Mount a partition |
| `getprop("key")` | Read a system property |

---

## assert() vs run_program()

```edify
# Stops installation if script exits with 1
assert(run_program("/sbin/sh", "/tmp/p/plugin/run.sh", "2") == 0);

# Continues even if script fails
run_program("/sbin/sh", "/tmp/p/plugin/run.sh", "2");
```

---

## Plugin Call Pattern

Always the same 3 steps:

```edify
# 1. Extract plugin from ZIP to /tmp/p/
package_extract_dir("plugins/PLUGIN_NAME", "/tmp/p/PLUGIN_NAME");

# 2. Run it (pass "2" as last arg — required for ui_print to work)
run_program("/sbin/sh", "/tmp/p/PLUGIN_NAME/run.sh", "2");

# 3. Wrap in assert() if plugin must be able to stop installation
assert(run_program("/sbin/sh", "/tmp/p/PLUGIN_NAME/run.sh", "2") == 0);
```
