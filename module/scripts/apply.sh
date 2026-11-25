#!/system/bin/sh
# Применяет активный профиль. Идемпотентно: повторный запуск ничего не ломает.

MODDIR=${MODDIR:-/data/adb/modules/hyperos_debloater}
export MODDIR
. "$MODDIR/scripts/common.sh"

ensure_dirs || exit 1
profile=$(current_profile)
profile_file="$MODDIR/profiles/$profile.txt"
if [ ! -f "$profile_file" ]; then
    log "Профиль '$profile' не найден: $profile_file"
    exit 1
fi

package_list
read_packages "$profile_file" >"$TMP_DIR/target.txt"
read_packages "$APPLIED_FILE" >"$TMP_DIR/previous.txt"
: >"$TMP_DIR/cleanup.txt"

# Возвращаем пакеты, которые выпали из нового профиля.
while IFS= read -r pkg; do
    [ -n "$pkg" ] || continue
    if ! grep -qx -- "$pkg" "$TMP_DIR/target.txt"; then
        if pm enable "$pkg" >/dev/null 2>&1; then
            printf '%s\n' "$pkg" >>"$TMP_DIR/cleanup.txt"
            log "ENABLE $pkg (больше не в профиле)"
        else
            log "ENABLE FAIL $pkg"
        fi
    fi
done <"$TMP_DIR/previous.txt"

disabled_now=0
skipped=0
while IFS= read -r pkg; do
    [ -n "$pkg" ] || continue
    if is_whitelisted "$pkg"; then
        log "SKIP whitelist $pkg"
        skipped=$((skipped + 1))
        continue
    fi
    if ! is_installed "$pkg"; then
        log "SKIP not installed $pkg"
        skipped=$((skipped + 1))
        continue
    fi
    if [ -f "$DRY_RUN_FILE" ]; then
        log "DRY-RUN disable $pkg"
        skipped=$((skipped + 1))
        continue
    fi
    if pm disable-user --user 0 "$pkg" >/dev/null 2>&1; then
        disabled_now=$((disabled_now + 1))
        log "DISABLE $pkg"
    else
        log "DISABLE FAIL $pkg"
    fi
done <"$TMP_DIR/target.txt"

# Фактически отключённые пакеты = пересечение профиля и списка отключённых pm.
pm list packages -d 2>/dev/null | sed 's/^package://' | sort -u >"$TMP_DIR/disabled.txt" || true
grep -Fxf "$TMP_DIR/target.txt" "$TMP_DIR/disabled.txt" >"$APPLIED_FILE" 2>/dev/null || : >"$APPLIED_FILE"

total=$(wc -l <"$APPLIED_FILE" 2>/dev/null | sed 's/[[:space:]]//g')
log "Профиль '$profile': отключено сейчас=$disabled_now, пропущено=$skipped, всего отключено=$total, возвращено=$(wc -l <"$TMP_DIR/cleanup.txt" 2>/dev/null | sed 's/[[:space:]]//g')"
