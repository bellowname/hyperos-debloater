# HyperOS Debloater (Safe Profiles)

[![build](https://github.com/bellowname/hyperos-debloater/actions/workflows/build.yml/badge.svg)](https://github.com/bellowname/hyperos-debloater/actions/workflows/build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Release](https://img.shields.io/github/v/release/bellowname/hyperos-debloater)](https://github.com/bellowname/hyperos-debloater/releases/latest)

[Русская версия](README_RU.md)

**Safely disable Xiaomi ads, analytics and bloat on HyperOS / MIUI — without deleting system apps.**

A Magisk module for Xiaomi, Redmi and POCO that turns annoying system services off with `pm disable-user`. Everything can be restored with one tap, and a clean WebUI makes it easy to use on **Magisk, KernelSU and APatch**.

![HyperOS Debloater WebUI](docs/screenshots/webui.jpg)

## Why another debloater?

- **Nothing is deleted.** Packages are only disabled, never uninstalled or wiped.
- **Three profiles:** `safe` → `balanced` → `aggressive`, switchable from Magisk Action or WebUI.
- **Safe-by-default whitelist:** launcher, keyguard, Security Center, Theme, Backup, Wallet, Google Play services and others are never touched.
- **Dry-run mode:** see what the module *would* disable before it does anything.
- **Full rollback:** uninstalling the module re-enables everything it disabled, including packages you disabled manually in the WebUI.
- **WebUI included:** profiles, per-package toggles, whitelist, log and scanner in a nice offline page via [KsuWebUI Standalone](https://github.com/5ec1cff/KsuWebUIStandalone).
- **Works everywhere:** on non-Xiaomi ROMs it simply finds nothing and changes nothing.

## Install

1. Download `hyperos-debloater.zip` from [Releases](https://github.com/bellowname/hyperos-debloater/releases/latest).
2. Magisk → Modules → **Install from storage** → select the zip → reboot.
3. Default profile is `safe`. Use Magisk **Action** to cycle profiles, or open the WebUI.
4. For the graphical menu, install [KsuWebUI Standalone](https://github.com/5ec1cff/KsuWebUIStandalone/releases) and open **HyperOS Debloater** from its module list.

## Profiles

| Profile | Disables | Risk |
|---|---|---|
| `safe` | ads, analytics, Yellow Page, bug reports | minimal |
| `balanced` | + GetApps/store, browser, video, Miracast, QR scanner | medium — whitelist what you use |
| `aggressive` | + Joyose, Discover, AOD, wallpapers, voice assistant, powerkeeper, game booster | higher — some Xiaomi features will disappear |

Full package list with descriptions: [docs/PACKAGES.md](docs/PACKAGES.md).

## WebUI

Magisk has no built-in WebUI, so this module uses the excellent
[KsuWebUIStandalone](https://github.com/5ec1cff/KsuWebUIStandalone) app by 5ec1cff.
It works with Magisk, KernelSU and APatch. After installing the module it appears in the app's list.

You can:

- switch profiles with one tap;
- enable/disable individual packages — choices survive reboot via `custom.txt`;
- tap ★ to add a package to the whitelist forever;
- enable dry-run and inspect the log;
- run the scanner and read its report inside the page;
- restore everything with the **Restore all** button (press twice to confirm).

The page is fully local (`webroot/index.html`), needs no internet and sends no telemetry.
Commands go through `scripts/webui.sh`, which only accepts known package names.

## Files and manual control

User files live in `/data/adb/hyperos_debloater`:

| File | Purpose |
|---|---|
| `profile` | active profile: `safe`, `balanced` or `aggressive` |
| `whitelist.txt` | packages the module must never touch |
| `custom.txt` | packages disabled manually in WebUI (survive reboot) |
| `applied.txt` | packages disabled by the module (used for restore) |
| `log.txt` | timestamped action log |
| `dry-run` | if present, nothing is disabled — only logged |

Examples in Termux with root:

```sh
# See which known packages are actually installed
su -c 'sh /data/adb/modules/hyperos_debloater/scripts/scan.sh'
# Report: /sdcard/Download/hyperos-debloater-packages.txt

# Dry run
su -c 'touch /data/adb/hyperos_debloater/dry-run'
su -c 'sh /data/adb/modules/hyperos_debloater/scripts/apply.sh'
cat /data/adb/hyperos_debloater/log.txt
su -c 'rm /data/adb/hyperos_debloater/dry-run'

# Select a profile manually
su -c 'echo balanced > /data/adb/hyperos_debloater/profile'
su -c 'sh /data/adb/modules/hyperos_debloater/scripts/apply.sh'

# Restore everything without uninstalling
su -c 'sh /data/adb/modules/hyperos_debloater/scripts/restore.sh'
```

## Supported devices

Any HyperOS 1.x/2.x or MIUI 12+ device. Developed and tested on a Redmi Note 12
(`tapas`, Snapdragon 685, Android 15 / HyperOS 2.0). On AOSP-like ROMs the module
finds no Xiaomi packages and does nothing.

## FAQ

**Something broke (launcher, lockscreen)?** Disable or uninstall the module in Magisk —
all packages are re-enabled. If the phone will not boot, delete
`/data/adb/modules/hyperos_debloater` from recovery.

**The log says `DISABLE FAIL` or `RESTORE FAIL`.** Update to v1.1.1 first: the module now
waits for PackageManager after boot, retries and logs the real `pm` error as
`PM DISABLE FAIL ...`. If it still fails, open an issue with that line from `log.txt`.

**Can I edit profiles?** Yes, but adding a package to `whitelist.txt` is safer — whitelist
entries survive module updates.

## Roadmap

- [x] WebUI with package toggles (Magisk / KernelSU / APatch via KsuWebUI)
- [ ] Region-specific profiles (Global / CN / EEA / RU)
- [ ] Community-maintained candidate list via `update.json`
- [ ] Notification after applying a profile

## Build

```sh
sh scripts/build.sh          # → hyperos-debloater.zip
```

Before releasing, replace `bellowname` in `module/module.prop`, `update.json`,
README badges and `LICENSE` with your GitHub username.

## Contributing

Package names differ between regions and ROMs. Run `scan.sh`, attach the report to an
issue, and read [CONTRIBUTING.md](CONTRIBUTING.md) before sending a PR.

## Disclaimer

This module changes the enabled state of system packages. Make a backup. The author is
not responsible for consequences. It is open source — read the code before installing.

## License

MIT. If this helped you, a ⭐ on GitHub is the best motivation to keep updating it.
