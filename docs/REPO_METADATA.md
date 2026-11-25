# Repository metadata (proposal)

All strings are fact-checked against the code. The module requires root; phrases like
"debloat without root" are deliberately not used.

## GitHub Description — 5 English options

1. `HyperOS debloater for Xiaomi/Redmi/POCO: safely disable ads and analytics with pm disable-user — no app deletion. 3 profiles, whitelist, dry-run, full rollback and offline WebUI via KsuWebUI. Magisk module; KernelSU/APatch untested.`
2. `Magisk module for HyperOS/Xiaomi debloat without deleting system apps: 3 profiles, whitelist, dry-run, rollback and KsuWebUI. Requires root. Tested on Redmi Note 12.`
3. `Xiaomi HyperOS debloater (requires root): disable ads, analytics and bloat safely. Profiles, protected whitelist, dry-run, full restore, WebUI. Magisk; KernelSU/APatch unverified.`
4. `Safe HyperOS/MIUI debloater for Xiaomi/Redmi/POCO. Systemless pm disable-user, no app deletion, whitelist, dry-run, restore on uninstall, WebUI via KsuWebUI. Root required.`
5. `HyperOS debloater / Magisk module for Xiaomi: disable ads and analytics without uninstalling apps. 3 profiles, dry-run, whitelist, rollback, KsuWebUI. Root required; KernelSU/APatch untested.`

**Recommended:** option 1 — it contains the key search phrases ("HyperOS debloater",
"Magisk module", "Xiaomi", "pm disable-user", "KsuWebUI") and states the compatibility
limits honestly.

Recommended Russian version (for mirrors / descriptions elsewhere):

> Безопасный HyperOS debloater для Xiaomi/Redmi/POCO: отключает рекламу и аналитику через pm disable-user, не удаляя приложения. 3 профиля, whitelist, dry-run, полный откат и WebUI через KsuWebUI. Требуется root; Magisk проверен, KernelSU/APatch — нет.

## Topics (19)

```text
hyperos
hyperos-debloat
xiaomi
xiaomi-debloat
redmi
poco
miui
debloater
magisk
magisk-module
kernelsu
apatch
android
android-root
root
systemless
privacy
modding
webui
```

`performance` and `battery` are intentionally **not** included: the module makes no
benchmarked performance or battery-life claim. `ksuwebui` can be added later if the
repository starts receiving related issues.

Current repository topics are a subset of this list; the missing ones are
`hyperos-debloat`, `xiaomi-debloat`, `systemless`, `modding`.

## Release title and notes

Title for the next stable release:

> v1.1.1 — безопасное отключение на HyperOS

Use `.github/RELEASE_TEMPLATE.md` as the body. It must mention:

- what changed (fix for `pm disable-user` / `pm enable`);
- what was tested (Redmi Note 12, HyperOS 2.0.209, Android 15, Magisk);
- what was **not** tested (KernelSU, APatch, other Android versions);
- install link and rollback instruction;
- backup warning.

## Pinned release

Pin **v1.1.1** as the latest stable release. Keep older releases visible but unpinned.
After a future v1.2.0 is verified on the same device, move the pin there.

## SEO words for the first paragraph

Use naturally, without keyword stuffing:

- "HyperOS debloater"
- "Magisk module for HyperOS"
- "Xiaomi debloat with root"
- "disable Xiaomi system apps without deleting them"
- "pm disable-user"
- "KsuWebUI"

Do not use: "debloat without root", "2x faster", "guarantees Play Integrity".
