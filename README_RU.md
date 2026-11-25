# HyperOS Debloater (Safe Profiles)

[English README](README.md) · [Русская версия](README_RU.md)

[![build](https://github.com/bellowname/hyperos-debloater/actions/workflows/build.yml/badge.svg)](https://github.com/bellowname/hyperos-debloater/actions/workflows/build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Magisk-модуль для Xiaomi / Redmi / POCO на HyperOS и MIUI. Отключает рекламные,
рекомендательные и аналитические сервисы — **без удаления системных приложений** и
с гарантированным возвратом при uninstall.

## Зачем ещё один debloater

- **Ничего не удаляется.** Только `pm disable-user`, всё восстанавливается командой `pm enable`.
- **Три профиля**: `safe` → `balanced` → `aggressive`, переключаются кнопкой Action в Magisk или в WebUI.
- **WebUI** (с 1.1.0): выбор профиля, выключатели пакетов, whitelist, dry-run и лог — через приложение
  [KsuWebUI](https://github.com/5ec1cff/KsuWebUIStandalone). Работает с Magisk, KernelSU и APatch.
- **Whitelist**-critical пакетов (`home`, `keyguard`, `securitycenter`, `theme`, `backup`, …)
  защищает устройство даже от ошибок в профиле.
- **Сухой прогон** (`dry-run`): сначала смотришь, что модуль *собирается* отключить.
- **Отчёт сканера**: список реально найденных на твоём устройстве пакетов.
- **Автовозврат**: при удалении модуля `uninstall.sh` включает всё отключённое им.
- Работает на любом ROM: на не-Xiaomi просто ничего не находит и не трогает систему.

## Установка

1. Скачай `hyperos-debloater.zip` из раздела **Releases**.
2. Magisk → Модули → **Установить с устройства** → выбери zip → перезагрузка.
3. После загрузки открой модуль и нажми **Action**, чтобы сменить профиль
   (`safe` → `balanced` → `aggressive` → `safe`).
4. Для красивого меню поставь [KsuWebUI](https://github.com/5ec1cff/KsuWebUIStandalone/releases)
   и открой **HyperOS Debloater** в списке модулей.

По умолчанию активен `safe`.

## WebUI (рекомендуется)

Встроенного WebUI в Magisk нет, поэтому используется отдельное приложение
[KsuWebUIStandalone](https://github.com/5ec1cff/KsuWebUIStandalone) от 5ec1cff.
После установки модуля он появится в списке приложения — достаточно нажать на него.

![Меню HyperOS Debloater в KsuWebUI](docs/screenshots/webui.jpg)

Что можно сделать в меню:

- выбрать профиль `safe` / `balanced` / `aggressive` одной кнопкой;
- включить/выключить конкретный пакет — выбор сохранится в `custom.txt` после перезагрузки;
- нажать ★, чтобы навсегда исключить пакет (добавить в `whitelist.txt`);
- включить «сухой прогон» и посмотреть лог перед применением;
- запустить сканер и прочитать отчёт прямо в окне;
- вернуть все пакеты кнопкой «Всё вернуть» (нужно нажать дважды).

Страница целиком лежит в модуле (`webroot/index.html`), не требует интернета и не
отправляет телеметрию. Все команды идут через защищённый бэкенд
`scripts/webui.sh`, который принимает только известные имена пакетов.

## Профили

| Профиль | Что отключает | Риск |
|---|---|---|
| `safe` | реклама, аналитика, `yellowpage`, bugreport | минимальный |
| `balanced` | + GetApps/магазин, браузер, видео, Miracast, сканер | средний — добавь нужное в whitelist |
| `aggressive` | + Joyose, discover, AOD, обои, голосовой помощник, powerkeeper, gamebooster | выше — часть фирменных фишек может пропасть |

Конкретный список и описания — в [docs/PACKAGES.md](docs/PACKAGES.md) и `module/profiles/*.txt`.

## Пути и ручное управление

Все пользовательские файлы лежат в `/data/adb/hyperos_debloater`:

| Файл | Назначение |
|---|---|
| `profile` | имя активного профиля (`safe`, `balanced`, `aggressive`) |
| `whitelist.txt` | пакеты, которые нельзя трогать |
| `custom.txt` | пакеты, отключённые вручную через WebUI (переживают перезагрузку) |
| `applied.txt` | пакеты, отключённые модулем (используется для возврата) |
| `log.txt` | журнал всех действий с датой и временем |
| `dry-run` | если файл существует — отключение не применяется, только лог |

Примеры команд (Termux, root):

```sh
# Посмотреть, какие кандидаты вообще есть на устройстве
su -c 'sh /data/adb/modules/hyperos_debloater/scripts/scan.sh'
# Отчёт появится в /sdcard/Download/hyperos-debloater-packages.txt

# Включить сухой прогон и применить
su -c 'touch /data/adb/hyperos_debloater/dry-run'
su -c 'sh /data/adb/modules/hyperos_debloater/scripts/apply.sh'
cat /data/adb/hyperos_debloater/log.txt

# Вернуть сухой прогон обратно
su -c 'rm /data/adb/hyperos_debloater/dry-run'

# Выбрать профиль вручную и применить
su -c 'echo balanced > /data/adb/hyperos_debloater/profile'
su -c 'sh /data/adb/modules/hyperos_debloater/scripts/apply.sh'

# Всё вернуть, не удаляя модуль
su -c 'sh /data/adb/modules/hyperos_debloater/scripts/restore.sh'
```

## Поддерживаемые устройства

Любые устройства на HyperOS 1.x/2.x и MIUI 12+. Разработка и тестирование идут на
Redmi Note 12 (`tapas`, Snapdragon 685, Android 15 / HyperOS 2.0). На AOSP-подобных
прошивках модуль просто не находит пакеты Xiaomi и ничего не меняет.

## Вопросы

**Сломался экран/лаунчер?** Открой Magisk → отключи модуль — при удалении все пакеты
включаются обратно. Если не перезагружается, в recovery удали
`/data/adb/modules/hyperos_debloater`.

**Модуль ничего не отключил.** Запусти `scan.sh`: возможно, на твоей прошивке другие
имена пакетов. Пришли отчёт в issue — добавим профиль под твою прошивку.

**В логе `DISABLE FAIL` или `RESTORE FAIL`.** Обновись до 1.1.1: модуль теперь ждёт
PackageManager после загрузки, повторяет попытку и пишет настоящую ошибку `pm` в лог
(`PM DISABLE FAIL ...`). Если ошибка останется — пришли строку `PM DISABLE FAIL` из
`log.txt` в issue.

**Можно ли редактировать профили?** Да, но правильнее добавить нужный пакет в
`whitelist.txt`: он сохранится при обновлении модуля.

## Roadmap

- [x] WebUI с чекбоксами пакетов (Magisk/KernelSU/APatch через KsuWebUI) — с 1.1.0
- [ ] Профили под конкретные регионы (Global / CN / EEA / RU)
- [ ] Обновляемый список кандидатов через `update.json`
- [ ] Уведомление после применения профиля

## Disclaimer

Модуль меняет состояние системных пакетов. Делай бэкап. Автор не несёт ответственности
за последствия. Это open source — читай код перед установкой.

## Сборка

```sh
sh scripts/build.sh          # → hyperos-debloater.zip
```

Репозиторий: `github.com/bellowname/hyperos-debloater`. Если логин изменится,
поправь его в `module/module.prop`, `update.json`, бейджах README и `LICENSE`.

## License

MIT. Свои пакеты и профили присылай через [CONTRIBUTING.md](CONTRIBUTING.md).
Если модуль помог — поставь ⭐, это главная мотивация обновлять его.
