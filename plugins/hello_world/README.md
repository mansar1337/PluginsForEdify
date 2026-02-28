# hello_world

Minimal example plugin. Use this as a template for your own plugins.

## updater-script

```edify
package_extract_dir("plugins/hello_world", "/tmp/p/hello_world");
run_program("/sbin/sh", "/tmp/p/hello_world/run.sh", "2");
```

## Output

```
------------------------------
 Hello World!
 Plugin работает!
------------------------------
```
