# Troubleshooting

## ui_print in log but nothing on screen

**Symptom:** recovery.log shows `ui_print Hello`, but screen is blank.

**Cause:** Writing to wrong file descriptor.

**Fix:** Use the pipe-finding block at the top of every `run.sh`:

```sh
OUTFD=1
for fd in /proc/$$/fd/*; do
    if readlink "$fd" 2>/dev/null | grep -q "^pipe:"; then
        OUTFD="${fd##*/}"
        break
    fi
done
OUTFD=/proc/self/fd/$OUTFD
```

---

## exit 1 does not stop installation

**Cause:** `run_program` return code is ignored by default.

**Fix:** Wrap in `assert()`:

```edify
assert(run_program("/sbin/sh", "/tmp/p/my_plugin/run.sh", "2") == 0);
```

---

## unknown function "set_perm"

**Cause:** `set_perm` is deprecated in TWRP 3.x+.

**Fix:** Use `run_program` with `chmod` instead:

```edify
run_program("/sbin/sh", "-c", "chmod 755 /path/to/file");
```

---

## can't create /proc/self/fd/N: No such file or directory

**Cause:** fd number found via `ls /proc/$$/fd` but writing to `/proc/self/fd/N` — the fd belongs to the parent process (update-binary), not current shell.

**Fix:** The pipe-finding loop uses `${fd##*/}` to get the fd number, then writes via `/proc/self/fd/$OUTFD`. This works because update-binary does **not** close inherited fds on fork — the child shell inherits all open fds including the recovery pipe.

---

## parse errors in updater-script

- Every statement must end with `;`
- All string arguments must be in `"double quotes"`
- No variables — EDIFY has no variable support
