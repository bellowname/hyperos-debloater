#!/system/bin/sh
# Ранняя инициализация: права, каталог настроек и нейтральная запись в лог.

MODDIR=${0%/*}
export MODDIR
chmod 0755 "$MODDIR/action.sh" "$MODDIR/uninstall.sh" 2>/dev/null || true
chmod -R 0755 "$MODDIR/scripts" 2>/dev/null || true

. "$MODDIR/scripts/common.sh"
ensure_dirs || exit 1
log "Модуль загружен. Профиль: $(current_profile)"
