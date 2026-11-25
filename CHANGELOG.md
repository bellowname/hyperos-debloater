# Changelog

## 1.1.0 (2026-11-25)

- **WebUI** для Magisk / KernelSU / APatch через приложение [KsuWebUI](https://github.com/5ec1cff/KsuWebUIStandalone):
  выбор профиля, список пакетов с выключателями, whitelist, dry-run, лог и сканер.
- Ручные выборы в WebUI сохраняются в `custom.txt` и переживают перезагрузку.
- Включение пакета через WebUI автоматически добавляет его в whitelist.
- `uninstall.sh` теперь возвращает и пакеты, отключённые вручную через WebUI.
- Обновлён `update.json` (версия 1.1.0).
- Сборщик zip теперь выставляет права 0755 на `.sh` и 0644 на остальные файлы.

## 1.0.0 (2026-11-25)

- Первый релиз.
- Три профиля: `safe`, `balanced`, `aggressive`.
- Переключение профиля кнопкой Action в Magisk.
- Whitelist критических пакетов.
- Сухой прогон через файл `dry-run`.
- Сканер установленных кандидатов (`scripts/scan.sh`).
- Полный возврат при uninstall через `uninstall.sh`.
- Сборка zip через GitHub Actions.
