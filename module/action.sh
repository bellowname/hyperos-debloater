#!/system/bin/sh
# Кнопка «Action» в Magisk: переключает safe -> balanced -> aggressive -> safe.

MODDIR=${0%/*}
export MODDIR
. "$MODDIR/scripts/common.sh"

ensure_dirs || exit 1
profile=$(current_profile)
case "$profile" in
safe) next=balanced ;;
balanced) next=aggressive ;;
*) next=safe ;;
esac

printf '%s\n' "$next" >"$PROFILE_FILE"
log "Переключение профиля: $profile -> $next"
sh "$MODDIR/scripts/apply.sh"
printf 'Профиль: %s\nЛог: %s/log.txt\n' "$next" "$WORK_DIR"
