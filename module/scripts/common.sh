#!/system/bin/sh
# Общие пути и функции. MODDIR/WORK_DIR можно переопределить извне (для тестов).

MODDIR=${MODDIR:-/data/adb/modules/hyperos_debloater}
WORK_DIR=${WORK_DIR:-/data/adb/hyperos_debloater}
TMP_DIR="$WORK_DIR/tmp"
LOG_FILE="$WORK_DIR/log.txt"
APPLIED_FILE="$WORK_DIR/applied.txt"
WHITELIST_FILE="$WORK_DIR/whitelist.txt"
CUSTOM_FILE="$WORK_DIR/custom.txt"
PROFILE_FILE="$WORK_DIR/profile"
DRY_RUN_FILE="$WORK_DIR/dry-run"

log() {
    printf '%s | %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >>"$LOG_FILE" 2>/dev/null || true
}

ensure_dirs() {
    mkdir -p "$WORK_DIR" "$TMP_DIR" 2>/dev/null || return 1
    [ -f "$LOG_FILE" ] || : >"$LOG_FILE" 2>/dev/null || true
    [ -f "$APPLIED_FILE" ] || : >"$APPLIED_FILE" 2>/dev/null || true
    [ -f "$CUSTOM_FILE" ] || : >"$CUSTOM_FILE" 2>/dev/null || true
    [ -f "$PROFILE_FILE" ] || printf 'safe\n' >"$PROFILE_FILE" 2>/dev/null || true
    if [ ! -f "$WHITELIST_FILE" ] && [ -f "$MODDIR/profiles/whitelist.txt" ]; then
        cp "$MODDIR/profiles/whitelist.txt" "$WHITELIST_FILE" 2>/dev/null || true
    fi
    return 0
}

current_profile() {
    profile=$(head -n 1 "$PROFILE_FILE" 2>/dev/null | sed 's/[[:space:]]//g')
    case "$profile" in
    safe | balanced | aggressive) printf '%s\n' "$profile" ;;
    *) printf 'safe\n' ;;
    esac
}

package_list() {
    pm list packages 2>/dev/null | sed 's/^package://' | sort -u >"$TMP_DIR/installed.txt" || true
}

is_installed() {
    grep -qx -- "$1" "$TMP_DIR/installed.txt" 2>/dev/null
}

is_whitelisted() {
    sed -e 's/#.*$//' -e 's/[[:space:]]//g' "$WHITELIST_FILE" 2>/dev/null | grep -qx -- "$1" 2>/dev/null
}

read_packages() {
    sed -e 's/#.*$//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' "$1" 2>/dev/null |
        tr -d '\r' | grep -v '^$' | sort -u
}

# Некоторые HyperOS-прошивки отказывают pm в первые секунды после загрузки
# или требуют явный --user. Пытаемся несколько раз и пишем настоящую ошибку в лог.
pm_disable() {
    pkg=$1
    out=$(pm disable-user --user 0 "$pkg" 2>&1)
    rc=$?
    if [ "$rc" -ne 0 ]; then
        sleep 2
        out=$(pm disable-user --user 0 "$pkg" 2>&1)
        rc=$?
    fi
    if [ "$rc" -ne 0 ]; then
        fallback=$(pm disable "$pkg" 2>&1)
        if [ $? -eq 0 ]; then
            log "PM fallback disable OK $pkg"
            return 0
        fi
        log "PM DISABLE FAIL $pkg: $out | fallback: $fallback"
        return 1
    fi
    [ -n "$out" ] && log "PM disable $pkg: $out"
    return 0
}

pm_enable() {
    pkg=$1
    out=$(pm enable --user 0 "$pkg" 2>&1)
    rc=$?
    if [ "$rc" -ne 0 ]; then
        fallback=$(pm enable "$pkg" 2>&1)
        if [ $? -eq 0 ]; then
            log "PM fallback enable OK $pkg"
            return 0
        fi
        log "PM ENABLE FAIL $pkg: $out | fallback: $fallback"
        return 1
    fi
    [ -n "$out" ] && log "PM enable $pkg: $out"
    return 0
}
