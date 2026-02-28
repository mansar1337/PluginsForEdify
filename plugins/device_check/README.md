# device_check

Checks the device codename before installation.  
Stops the installation immediately if the device does not match.

## Files

```
plugins/device_check/
├── run.sh         ← main script
└── config.prop    ← allowed devices list
```

## Config

Edit `config.prop`:

```properties
# Allowed device codenames (comma-separated)
ALLOWED_DEVICES=cepheus,raphael,davinci

# What to do on mismatch:
#   abort — stop installation (use with assert() in updater-script)
#   warn  — print warning and continue
ON_MISMATCH=abort
```

## updater-script

```edify
package_extract_dir("plugins/device_check", "/tmp/p/device_check");
assert(run_program("/sbin/sh", "/tmp/p/device_check/run.sh", "2") == 0);
```

> `assert()` is required — otherwise `exit 1` will not stop the installation.

## Output Example

**Match:**
```
Проверка устройства...
Кодовое имя: cepheus
[OK] Устройство совместимо!
```

**Mismatch:**
```
Проверка устройства...
Кодовое имя: whyred
[СТОП] Неверное устройство!
Ожидалось: cepheus,raphael,davinci
Установка прервана.
```
