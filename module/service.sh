#!/system/bin/sh
# Ждём завершения загрузки и применяем профиль в фоне.

MODDIR=${0%/*}
export MODDIR

(
    attempts=0
    while [ "$(getprop sys.boot_completed 2>/dev/null)" != "1" ]; do
        attempts=$((attempts + 1))
        [ "$attempts" -gt 180 ] && exit 0
        sleep 5
    done
    sleep 20

    . "$MODDIR/scripts/common.sh"
    log "Boot completed, применяю профиль $(current_profile)"
    sh "$MODDIR/scripts/apply.sh"
) &
