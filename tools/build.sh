#!/bin/bash
# Build firmware.zip with all plugins
# Usage: ./tools/build.sh [output_name]

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT_NAME="${1:-firmware.zip}"
OUTPUT="$PROJECT_DIR/build/$OUTPUT_NAME"

echo "[*] Cleaning build dir..."
rm -rf "$PROJECT_DIR/build"
mkdir -p "$PROJECT_DIR/build"

echo "[*] Building $OUTPUT_NAME..."
cd "$PROJECT_DIR"
zip -r "$OUTPUT" \
    META-INF/ \
    plugins/

echo "[*] Done!"
echo "    Output : $OUTPUT"
echo "    Size   : $(du -sh "$OUTPUT" | cut -f1)"
