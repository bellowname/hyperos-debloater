#!/system/bin/sh
# Возвращает только те пакеты, которые отключил этот модуль.

MODDIR=${MODDIR:-/data/adb/modules/hyperos_debloater}
export MODDIR
. "$MODDIR/scripts/common.sh"

ensure_dirs || exit 1
restored=0
while IFS= read -r pkg; do
    [ -n "$pkg" ] || continue
    if pm_enable "$pkg"; then
        restored=$((restored + 1))
        log "RESTORE $pkg"
    else
        log "RESTORE FAIL $pkg"
    fi
done <"$APPLIED_FILE"
: >"$APPLIED_FILE"
log "Восстановлено пакетов: $restored"
