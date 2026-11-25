# HyperOS Debloater (Safe Profiles)

[![Release](https://img.shields.io/github/v/release/bellowname/hyperos-debloater?display_name=tag)](https://github.com/bellowname/hyperos-debloater/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Magisk](https://img.shields.io/badge/Magisk-проверен-orange)
![KernelSU](https://img.shields.io/badge/KernelSU-не_проверен-lightgrey)
![APatch](https://img.shields.io/badge/APatch-не_проверен-lightgrey)
![HyperOS](https://img.shields.io/badge/HyperOS-1.x%2F2.x-blue)

[English README](README.md) · [Список пакетов](docs/PACKAGES.md) · [Безопасность](SECURITY.md)

**HyperOS debloater для Xiaomi, Redmi и POCO: безопасно отключает рекламу, аналитику и лишние сервисы через `pm disable-user`, а не удаляет системные приложения.**

Это **Magisk-модуль** для устройств с root. Он не удаляет приложения и не трогает `/system`: только меняет состояние пакетов и умеет всё вернуть при удалении. Три профиля (`safe`, `balanced`, `aggressive`), защищённый whitelist, dry-run и офлайн-WebUI делают процесс проверяемым и обратимым.

> Root обязателен. Это **не** решение «debloat без root».

![HyperOS Debloater WebUI](docs/screenshots/webui.jpg)

## Что это и чем отличается от удаления приложений

Системные пакеты Xiaomi нельзя просто удалить из настроек, а удаление из `/system` опасно и ломает OTA. Модуль:

- выполняет `pm disable-user --user 0 <package>` для фиксированного списка;
- не удаляет APK и не чистит данные приложений;
- запоминает всё, что отключил;
- включает пакеты обратно при удалении модуля;
- защищает критичные приложения whitelist-ом, даже если они есть в профиле.

Точный список — в [docs/PACKAGES.md](docs/PACKAGES.md).

## Безопасность

| Свойство | Как реализовано |
|---|---|
| Без изменений `/system` | Меняется только состояние пакетов; файлы модуля лежат в `/data/adb/hyperos_debloater` |
| Обратимость | `uninstall.sh` выполняет `pm enable` для пакетов из `applied.txt` и `custom.txt` |
| Защищённые компоненты | Лаунчер, экран блокировки, Security Center, Security Core, Theme, Backup, Face, Gallery, Wallet, Find Device, Smart Home и `com.google.android.gms` — в whitelist по умолчанию |
| Предпросмотр | Файл `dry-run` или переключатель в WebUI: действия пишутся в лог, но не применяются |
| Без телеметрии | WebUI — локальная страница, модуль не делает сетевых запросов |
| Видимость ошибок | Настоящие ошибки `pm` пишутся в `log.txt` как `PM DISABLE FAIL ...` |

Профиль по умолчанию — `safe`. Начни с него, запусти сканер и только потом думай о `balanced` или `aggressive`.

## Поддержка

Проверено автором только то, что указано ниже. Остальное помечено как требующее тестирования.

| Что | Статус | Примечание |
|---|---|---|
| Устройство | Redmi Note 12, кодовое имя `tapas` | Проверено |
| HyperOS | 2.0.209.0 | Проверено |
| Android | 15 | Проверено |
| Root / формат модуля | Magisk | Проверено на v1.1.1 |
| KernelSU | **Требует тестирования** | Скрипты в формате Magisk; автор не проверял |
| APatch | **Требует тестирования** | Скрипты в формате Magisk; автор не проверял |
| WebUI | KsuWebUI Standalone | Нужен отдельно; само приложение поддерживает Magisk / KernelSU / APatch |
| Другие HyperOS 1.x/2.x | **Требует тестирования** | Код проверяет только имена пакетов, без привязки к модели |
| Другие версии Android | **Требует тестирования** | Синтаксис `pm` может отличаться |
| AOSP-подобные прошивки | Ожидается «ничего не делать» | Кандидаты Xiaomi не найдутся; отдельно не тестировалось |

## Установка

1. Скачай `hyperos-debloater.zip` из [Releases](https://github.com/bellowname/hyperos-debloater/releases/latest).
2. Magisk → Модули → **Установить с устройства** → выбери zip → перезагрузка.
   В KernelSU / APatch порядок действий может отличаться и автором не проверен.
3. После загрузки автоматически применяется профиль `safe`.
4. Необязательно: поставь [KsuWebUI Standalone](https://github.com/5ec1cff/KsuWebUIStandalone/releases) для графического меню.

## Профили

| Профиль | Что отключает | Риск |
|---|---|---|
| `safe` (по умолчанию) | `com.miui.analytics`, `com.miui.systemAdSolution`, `com.miui.msa.global`, `com.miui.yellowpage`, `com.miui.bugreport` | Минимальный: реклама, аналитика, «жёлтые страницы», отчёты об ошибках |
| `balanced` | Всё из `safe` + браузер, GetApps/магазин, Xiaomi Shop, Mi Video, Miracast, сканер QR, hybrid-сервисы | Средний: встроенные приложения, которыми ты пользуешься, перестанут работать |
| `aggressive` | Всё из `balanced` + Joyose, Discover, AOD, обои, голосовой помощник, powerkeeper, luckymoney, game booster | Выше: игровые профили, AOD и часть фирменных функций могут пропасть |

Отсутствующие пакеты пропускаются. Перед выбором более жёсткого профиля запусти сканер.

## WebUI

У Magisk нет встроенного WebUI. Модуль содержит локальную страницу `webroot/index.html`; открой её через **KsuWebUI Standalone** от 5ec1cff.

1. Установи KsuWebUI Standalone из раздела Releases проекта.
2. Разреши root при запросе.
3. Открой **HyperOS Debloater** в списке модулей.

В WebUI можно переключать профили, включать/выключать отдельные пакеты, править whitelist, включать dry-run, запускать сканер и читать лог. Выбор сохраняется в `custom.txt` и переживает перезагрузку.

## Dry-run

Создай файл-маркер и примени профиль — ничего не отключится, только запишется в лог:

```sh
su -c 'touch /data/adb/hyperos_debloater/dry-run'
su -c 'sh /data/adb/modules/hyperos_debloater/scripts/apply.sh'
cat /data/adb/hyperos_debloater/log.txt | grep DRY-RUN
```

Убери маркер, чтобы изменения применились:

```sh
su -c 'rm /data/adb/hyperos_debloater/dry-run'
```

Тот же переключатель есть в WebUI.

## Откат

- **Оставить модуль:** WebUI → **«Всё вернуть»** (нажать дважды) либо
  `su -c 'sh /data/adb/modules/hyperos-debloater/scripts/restore.sh'`.
- **Удалить модуль:** удали его в Magisk. `uninstall.sh` включит пакеты из `applied.txt` и `custom.txt`.
- **Не загружается:** зайди в recovery и удали `/data/adb/modules/hyperos_debloater`. При необходимости убери файлы-маркеры в `/data/adb/hyperos_debloater`.

## FAQ и устранение неполадок

**Приложение пропало.** Скорее всего, оно отключено профилем. Проверь `applied.txt`, добавь пакет в `whitelist.txt` (или нажми ★ в WebUI), затем выполни `restore.sh`.

**Bootloop.** Удали каталог модуля из recovery. Не применяй `aggressive` на непроверенном устройстве.

**OTA-обновление.** Состояние отключённых пакетов может сброситься; после OTA это не тестировалось. После обновления проверь `log.txt` и при необходимости примени профиль заново.

**SafetyNet / Play Integrity.** Модуль не скрывает root и не обещает исправить Play Integrity. Тесты не проводились.

**HyperOS 2 / `DISABLE FAIL`.** Поставь v1.1.1 или новее: модуль ждёт PackageManager, повторяет попытку и пишет настоящую ошибку. Если строка `PM DISABLE FAIL ...` остаётся — открой issue с этой строкой и отчётом сканера.

**Не-Xiaomi прошивка.** Код ищет конкретные пакеты Xiaomi и пропускает отсутствующие. Привязки к модели нет; ожидается отсутствие изменений, но отдельно не проверялось.

## Скриншоты

Чеклист кадров — в [docs/SCREENSHOTS.md](docs/SCREENSHOTS.md).

Сейчас есть:

1. `docs/screenshots/webui.jpg` — **главный экран WebUI: профили, список пакетов и выключатели**.

Полезные кадры, которых пока нет:

2. Включённый dry-run и строки `DRY-RUN disable ...` в `log.txt`.
3. Отчёт сканера из `/sdcard/Download/hyperos-debloater-packages.txt`.
4. WebUI после «Всё вернуть» с логом `RESTORE`.
5. Страница модуля в Magisk с кнопкой **Action**.

## Лицензия и дисклеймер

MIT — см. [LICENSE](LICENSE). Сообщения об уязвимостях: [SECURITY.md](SECURITY.md). Вклад: [CONTRIBUTING.md](CONTRIBUTING.md).

**Сделай бэкап и сначала используй dry-run.** Модуль меняет состояние системных пакетов. Автор не несёт ответственности за потерю данных, сбои загрузки, проблемы после OTA, недоступность приложений, платежных/банковских приложений, гарантийные случаи, результат Play Integrity и любые другие последствия использования. Это open source — прочитай код перед установкой.
