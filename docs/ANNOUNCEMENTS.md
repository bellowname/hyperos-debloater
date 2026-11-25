# Announcement drafts

No stars-for-favors, no mass posting, no fake reviews. Post once per community, adapt
the text to its rules, and answer questions in the thread.

## 1. XDA (technical)

**Title:** `[MODULE] HyperOS Debloater — reversible pm disable-user profiles + WebUI for Xiaomi/Redmi/POCO`

**Body:**

> I built a small Magisk module for HyperOS/MIUI that disables ads, analytics and
> recommendation services without deleting system apps.
>
> How it works: a fixed package list is disabled with `pm disable-user --user 0`.
> There is no `/system` mount, no APK removal and no network traffic. Everything the
> module disabled is recorded in `/data/adb/hyperos_debloater/applied.txt` and is
> re-enabled by `uninstall.sh`.
>
> - Three profiles: `safe` (ads/analytics), `balanced`, `aggressive`
> - Protected whitelist: launcher, keyguard, Security Center, Theme, Backup,
>   Wallet, Google Play services
> - Dry-run marker and timestamped log
> - Offline WebUI via KsuWebUI Standalone
>
> Tested on Redmi Note 12 (`tapas`), HyperOS 2.0.209, Android 15, Magisk.
> KernelSU/APatch use compatible script formats but are **not verified yet**.
> This module does not hide root and does not claim Play Integrity fixes.
>
> Repo: https://github.com/bellowname/hyperos-debloater
>
> Backup first and try dry-run. Bug reports with `PM DISABLE FAIL ...` lines and
> `scan.sh` output are especially welcome.

## 2. Reddit — r/Xiaomi or r/Magisk

**Title:** `I made a reversible HyperOS debloater with profiles and an offline WebUI (root required)`

**Body:**

> I got tired of ads and analytics on my Redmi Note 12, so I made a small module that
> disables those system services instead of deleting them. It uses
> `pm disable-user`, keeps a whitelist for critical apps, has a dry-run mode and can
> restore everything when uninstalled.
>
> There are three profiles — `safe`, `balanced` and `aggressive` — plus a local WebUI
> if you install KsuWebUI Standalone.
>
> Repo: https://github.com/bellowname/hyperos-debloater
>
> Tested only on HyperOS 2.0 / Android 15 with Magisk. KernelSU/APatch and other
> devices still need reports. Requires root; it does not bypass Play Integrity.
> Backup first. Feedback about package names on other regions would be really useful.

## 3. 4PDA

**Title:** `[МОДУЛЬ] HyperOS Debloater — безопасное отключение рекламы и сервисов Xiaomi (Magisk, WebUI)`

**Body:**

> Что делает: отключает рекламные, аналитические и рекомендательные сервисы HyperOS
> через `pm disable-user`, **не удаляя приложения** и не трогая `/system`.
>
> Почему безопаснее обычного debloat:
>
> - есть whitelist лаунчера, экрана блокировки, Security Center, Theme, Backup,
>   Wallet и Google Play services;
> - есть dry-run — сначала смотрим лог, потом применяем;
> - при удалении модуля `uninstall.sh` включает всё обратно;
> - есть офлайн-WebUI через KsuWebUI Standalone.
>
> Профили: `safe` (реклама/аналитика), `balanced` (+магазины/браузер/видео),
> `aggressive` (+Joyose, AOD, powerkeeper, game booster — часть фишек пропадёт).
>
> Установка: скачать zip из Releases → установить в Magisk → перезагрузка →
> при необходимости поставить KsuWebUI Standalone и открыть модуль в нём.
>
> Проверено: Redmi Note 12 (`tapas`), HyperOS 2.0.209, Android 15, Magisk.
> KernelSU/APatch и другие прошивки — требует тестирования. Root обязателен;
> модуль не скрывает root и не обещает исправить Play Integrity.
>
> Ссылка: https://github.com/bellowname/hyperos-debloater
>
> Делай бэкап и сначала используй dry-run. Автор не несёт ответственности за
> последствия.

## 4. Telegram (5–7 строк)

```text
HyperOS Debloater v1.1.1 — модуль для Xiaomi/Redmi/POCO с root.

Отключает рекламу и аналитику через pm disable-user, не удаляя приложения.
Есть профили safe / balanced / aggressive, whitelist, dry-run и офлайн-WebUI через KsuWebUI Standalone.
При удалении модуля всё включется обратно.

Проверено на Redmi Note 12, HyperOS 2.0, Android 15, Magisk. KernelSU/APatch пока не проверены.
Не обещает ускорение и не скрывает root. Делай бэкап, сначала используй dry-run.

https://github.com/bellowname/hyperos-debloater
```

Fix typo "включется" -> "включается" before write? I already wrote with typo in content string. Need edit after. Let's fix<tool_call:6124c78e>edit<arg_key:6124c78e>path</arg_key:6124c78e><arg_value:6124c78e>/storage/emulated/0/Documents/hyperos-debloater/docs/ANNOUNCEMENTS.md