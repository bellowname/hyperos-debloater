#!/system/bin/sh
# Magisk вызывает этот скрипт при удалении модуля.

MODDIR=${0%/*}
export MODDIR
. "$MODDIR/scripts/common.sh"

sh "$MODDIR/scripts/restore.sh" || true
cp "$LOG_FILE" /sdcard/Download/hyperos-debloater-uninstall.log 2>/dev/null || true
rm -rf "$WORK_DIR" 2>/dev/null || true
