#!/system/bin/sh
# Запуск вручную: su -c 'sh /data/adb/modules/hyperos_debloater/scripts/scan.sh'
# Пишет отчёт с найденными кандидатами в /sdcard/Download.

MODDIR=${0%/*}
[ -d "$MODDIR/scripts" ] || MODDIR=$(dirname "$MODDIR")
export MODDIR
. "$MODDIR/scripts/common.sh"

ensure_dirs || exit 1
package_list
grep -Fxf "$MODDIR/profiles/candidates.txt" "$TMP_DIR/installed.txt" >"$TMP_DIR/found.txt" 2>/dev/null || : >"$TMP_DIR/found.txt"

report=/sdcard/Download/hyperos-debloater-packages.txt
{
    printf '# HyperOS Debloater: найденные кандидаты\n'
    printf '# Профиль сейчас: %s\n\n' "$(current_profile)"
    cat "$TMP_DIR/found.txt"
} >"$report" 2>/dev/null

printf 'Отчёт: %s\nНайдено: %s\n' "$report" "$(wc -l <"$TMP_DIR/found.txt" | sed 's/[[:space:]]//g')"
