# confirm

Shows a confirmation prompt during installation.
User presses **Vol+** to continue or **Vol-** to abort.

## Config

```properties
# Message shown on screen
MESSAGE=Do you want to continue installation?
```

## updater-script

```edify
package_extract_dir("plugins/confirm", "/tmp/p/confirm");
assert(run_program("/sbin/sh", "/tmp/p/confirm/run.sh", "2") == 0);
```

## Output

```
===============================
 Do you want to continue installation?
===============================
  Vol+  -->  Yes, continue
  Vol-  -->  No, abort
```

**Vol+ pressed:**
```
[OK] Confirmed! Continuing...
```

**Vol- pressed:**
```
[ABORT] Cancelled by user.
```

## Tip

You can use it multiple times in one `updater-script` with different messages — for example to confirm wiping data:

```edify
# First confirm: start install
package_extract_dir("plugins/confirm", "/tmp/p/confirm");
assert(run_program("/sbin/sh", "/tmp/p/confirm/run.sh", "2") == 0);

# ... install system ...

# Second confirm: wipe data?
package_extract_dir("plugins/confirm", "/tmp/p/confirm2");
assert(run_program("/sbin/sh", "/tmp/p/confirm2/run.sh", "2") == 0);
```
