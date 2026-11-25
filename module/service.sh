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
    sleep 30

    # На HyperOS package manager иногда встаёт не сразу после boot_completed.
    tries=0
    until pm list packages >/dev/null 2>&1; do
        tries=$((tries + 1))
        [ "$tries" -gt 30 ] && break
        sleep 2
    done

    . "$MODDIR/scripts/common.sh"
    log "Boot completed, применяю профиль $(current_profile)"
    sh "$MODDIR/scripts/apply.sh"
) &
