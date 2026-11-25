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
            arcname = os.path.relpath(path, module_dir)
            info = zipfile.ZipInfo.from_file(path, arcname)
            mode = 0o100755 if name.endswith(".sh") else 0o100644
            info.external_attr = (mode << 16) | (info.external_attr & 0xffff)
            with open(path, "rb") as source:
                archive.writestr(info, source.read(), compress_type=zipfile.ZIP_DEFLATED)
print(output)
PY
