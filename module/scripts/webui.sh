#!/system/bin/sh
# Backend для WebUI (ksuWebUI / KernelSU WebUI).
# ВАЖНО: страница не может передать произвольную команду — только имена
# поддерживаемых пакетов и фиксированные действия.

MODDIR=${0%/*}
MODDIR=${MODDIR%/scripts}
export MODDIR
. "$MODDIR/scripts/common.sh"

die() {
    printf 'ERR %s\n' "$1"
    exit 1
}

valid_pkg() {
    printf '%s' "$1" | grep -Eq '^[A-Za-z][A-Za-z0-9_]*(\.[A-Za-z][A-Za-z0-9_]*)+$'
}

known_pkg() {
    valid_pkg "$1" || return 1
    read_packages "$MODDIR/profiles/candidates.txt" >"$TMP_DIR/known.txt"
    [ -f "$CUSTOM_FILE" ] && read_packages "$CUSTOM_FILE" >>"$TMP_DIR/known.txt"
    sort -u "$TMP_DIR/known.txt" >"$TMP_DIR/known.sorted.txt"
    grep -qx -- "$1" "$TMP_DIR/known.sorted.txt"
}

append_unique() {
    grep -qx -- "$2" "$1" 2>/dev/null || printf '%s\n' "$2" >>"$1"
}

remove_line() {
    grep -vx -- "$2" "$1" >"$TMP_DIR/remove.new" 2>/dev/null || : >"$TMP_DIR/remove.new"
    mv "$TMP_DIR/remove.new" "$1"
}

count_lines() {
    wc -l <"$1" 2>/dev/null | sed 's/[[:space:]]//g'
}

ensure_dirs || die 'не удалось создать каталог настроек'
cmd=${1:-status}
shift || true

case "$cmd" in
status)
    version=$(grep '^version=' "$MODDIR/module.prop" 2>/dev/null | head -n 1 | cut -d= -f2-)
    printf 'version=%s\n' "${version:-unknown}"
    printf 'profile=%s\n' "$(current_profile)"
    if [ -f "$DRY_RUN_FILE" ]; then printf 'dryrun=on\n'; else printf 'dryrun=off\n'; fi
    printf 'applied=%s\n' "$(count_lines "$APPLIED_FILE")"
    printf 'custom=%s\n' "$(count_lines "$CUSTOM_FILE")"
    printf 'whitelist=%s\n' "$(count_lines "$WHITELIST_FILE")"
    ;;

list)
    package_list
    pm list packages -d 2>/dev/null | sed 's/^package://' | sort -u >"$TMP_DIR/ui-disabled.txt" || true
    {
        read_packages "$MODDIR/profiles/candidates.txt"
        read_packages "$CUSTOM_FILE"
    } | sort -u >"$TMP_DIR/ui-all.txt"
    {
        read_packages "$MODDIR/profiles/$(current_profile).txt"
        read_packages "$CUSTOM_FILE"
    } | sort -u >"$TMP_DIR/ui-target.txt"

    while IFS= read -r pkg; do
        [ -n "$pkg" ] || continue
        installed=0
        enabled=1
        whitelisted=0
        applied=0
        inprofile=0
        is_installed "$pkg" && installed=1
        grep -qx -- "$pkg" "$TMP_DIR/ui-disabled.txt" && enabled=0
        is_whitelisted "$pkg" && whitelisted=1
        grep -qx -- "$pkg" "$APPLIED_FILE" && applied=1
        grep -qx -- "$pkg" "$TMP_DIR/ui-target.txt" && inprofile=1
        printf '%s|%s|%s|%s|%s|%s\n' "$pkg" "$installed" "$enabled" "$whitelisted" "$applied" "$inprofile"
    done <"$TMP_DIR/ui-all.txt"
    ;;

set-profile)
    profile=${1:-}
    case "$profile" in
    safe | balanced | aggressive) ;;
    *) die 'неизвестный профиль' ;;
    esac
    printf '%s\n' "$profile" >"$PROFILE_FILE"
    log "WebUI: профиль -> $profile"
    sh "$MODDIR/scripts/apply.sh" || die 'не удалось применить профиль'
    printf 'OK profile=%s\n' "$profile"
    ;;

apply)
    sh "$MODDIR/scripts/apply.sh" || die 'не удалось применить профиль'
    printf 'OK applied\n'
    ;;

toggle)
    pkg=${1:-}
    action=${2:-}
    known_pkg "$pkg" || die 'пакет не поддерживается'
    is_installed "$pkg" || die 'пакет не установлен'
    case "$action" in
    disable)
        is_whitelisted "$pkg" && die 'пакет в whitelist — сначала убери исключение'
        if pm disable-user --user 0 "$pkg" >/dev/null 2>&1; then
            append_unique "$CUSTOM_FILE" "$pkg"
            append_unique "$APPLIED_FILE" "$pkg"
            log "WebUI DISABLE $pkg (сохранено в custom.txt)"
            printf 'OK disabled %s\n' "$pkg"
        else
            die "не удалось отключить $pkg"
        fi
        ;;
    enable)
        if pm enable "$pkg" >/dev/null 2>&1; then
            remove_line "$CUSTOM_FILE" "$pkg"
            remove_line "$APPLIED_FILE" "$pkg"
            append_unique "$WHITELIST_FILE" "$pkg"
            log "WebUI ENABLE $pkg (добавлено в whitelist)"
            printf 'OK enabled %s\n' "$pkg"
        else
            die "не удалось включить $pkg"
        fi
        ;;
    *) die 'ожидалось disable или enable' ;;
    esac
    ;;

whitelist)
    pkg=${1:-}
    action=${2:-}
    known_pkg "$pkg" || die 'пакет не поддерживается'
    case "$action" in
    add)
        append_unique "$WHITELIST_FILE" "$pkg"
        log "WebUI whitelist + $pkg"
        printf 'OK whitelisted %s\n' "$pkg"
        ;;
    remove)
        read_packages "$MODDIR/profiles/whitelist.txt" | grep -qx -- "$pkg" &&
            die 'встроенное исключение удалять нельзя'
        remove_line "$WHITELIST_FILE" "$pkg"
        log "WebUI whitelist - $pkg"
        printf 'OK unwhitelisted %s\n' "$pkg"
        ;;
    *) die 'ожидалось add или remove' ;;
    esac
    ;;

dry-run)
    action=${1:-}
    case "$action" in
    on)
        : >"$DRY_RUN_FILE"
        log 'WebUI: dry-run ВКЛЮЧЁН'
        printf 'OK dry-run=on\n'
        ;;
    off)
        rm -f "$DRY_RUN_FILE" 2>/dev/null || true
        log 'WebUI: dry-run ВЫКЛЮЧЕН'
        printf 'OK dry-run=off\n'
        ;;
    *) die 'ожидалось on или off' ;;
    esac
    ;;

restore)
    : >"$CUSTOM_FILE" 2>/dev/null || true
    sh "$MODDIR/scripts/restore.sh" || die 'не удалось восстановить пакеты'
    printf 'OK restored\n'
    ;;

scan)
    sh "$MODDIR/scripts/scan.sh" || die 'сканирование не удалось'
    ;;

report)
    report=/sdcard/Download/hyperos-debloater-packages.txt
    [ -f "$report" ] || die 'отчёт ещё не создан — нажми «Сканировать»'
    cat "$report"
    ;;

log)
    lines=${1:-120}
    printf '%s' "$lines" | grep -Eq '^[0-9]+$' || die 'неверное число строк'
    [ "$lines" -gt 500 ] && lines=500
    tail -n "$lines" "$LOG_FILE" 2>/dev/null || true
    ;;

*)
    die 'неизвестная команда'
    ;;
esac
