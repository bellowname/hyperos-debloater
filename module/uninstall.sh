#!/system/bin/sh
# Magisk вызывает этот скрипт при удалении модуля.

MODDIR=${0%/*}
export MODDIR
. "$MODDIR/scripts/common.sh"

sh "$MODDIR/scripts/restore.sh" || true
# Пакеты, отключённые вручную через WebUI, тоже возвращаем.
while IFS= read -r pkg; do
    [ -n "$pkg" ] || continue
    pm enable "$pkg" >/dev/null 2>&1 || true
done <"$CUSTOM_FILE" 2>/dev/null
cp "$LOG_FILE" /sdcard/Download/hyperos-debloater-uninstall.log 2>/dev/null || true
rm -rf "$WORK_DIR" 2>/dev/null || true
