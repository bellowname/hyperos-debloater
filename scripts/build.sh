#!/bin/sh
# Собирает flashable-zip для Magisk: module.prop лежит в корне архива.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
OUT="$ROOT/hyperos-debloater.zip"

python3 - "$ROOT/module" "$OUT" <<'PY'
import os
import sys
import zipfile

module_dir, output = sys.argv[1], sys.argv[2]
with zipfile.ZipFile(output, "w", zipfile.ZIP_DEFLATED) as archive:
    for base, dirs, files in os.walk(module_dir):
        dirs.sort()
        files.sort()
        for name in files:
            path = os.path.join(base, name)
            archive.write(path, os.path.relpath(path, module_dir))
print(output)
PY
