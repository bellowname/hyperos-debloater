# HyperOS Debloater (Safe Profiles)

[![Release](https://img.shields.io/github/v/release/bellowname/hyperos-debloater?display_name=tag)](https://github.com/bellowname/hyperos-debloater/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Magisk](https://img.shields.io/badge/Magisk-tested-orange)
![KernelSU](https://img.shields.io/badge/KernelSU-unverified-lightgrey)
![APatch](https://img.shields.io/badge/APatch-unverified-lightgrey)
![HyperOS](https://img.shields.io/badge/HyperOS-1.x%2F2.x-blue)

[Русская версия](README_RU.md) · [Packages](docs/PACKAGES.md) · [Security policy](SECURITY.md)

**HyperOS debloater for Xiaomi, Redmi and POCO: it safely disables ads, analytics and bloat with `pm disable-user` instead of deleting system apps.**

This is a **Magisk module** for rooted devices. It does not remove applications: it only changes their enabled state and can restore everything on uninstall. A three-profile system (`safe`, `balanced`, `aggressive`), a protected whitelist, dry-run mode and an offline WebUI make the process reviewable and reversible.

> Requires root. This is **not** a "debloat without root" solution.

![HyperOS Debloater WebUI](docs/screenshots/webui.jpg)

## What it is / why not just delete apps

Most Xiaomi system packages cannot be uninstalled from Settings, and deleting them from `/system` is risky and breaks OTA updates. This module:

- calls `pm disable-user --user 0 <package>` for a fixed list of packages;
- never removes APKs or wipes data;
- keeps a list of everything it disabled;
- re-enables those packages when the module is uninstalled;
- protects critical packages with a whitelist, even if a profile lists them.

Read the exact list in [docs/PACKAGES.md](docs/PACKAGES.md).

## Safety model

| Property | Implementation |
|---|---|
| No `/system` modification | Only package-manager state is changed; files are kept in `/data/adb/hyperos_debloater` |
| Reversible | `uninstall.sh` calls `pm enable` for packages from `applied.txt` and `custom.txt` |
| Protected components | Launcher, keyguard, Security Center, Security Core, Theme, Backup, Face, Gallery, Wallet, Find Device, Smart Home and `com.google.android.gms` are whitelisted by default |
| Preview before action | `dry-run` file or WebUI switch — actions are logged but not applied |
| No telemetry | WebUI is a local page; no network requests are made by the module |
| Failure visibility | Real `pm` errors are written to `log.txt` as `PM DISABLE FAIL ...` |

The default profile is `safe`. Start with it, run the scanner, and only then consider `balanced` or `aggressive`.

## Support matrix

Only the following has been verified by the author. Everything else is marked as needing confirmation.

| Item | Status | Notes |
|---|---|---|
| Device | Redmi Note 12, codename `tapas` | Verified |
| HyperOS | 2.0.209.0 | Verified |
| Android | 15 | Verified |
| Root / module format | Magisk | Verified on v1.1.1 |
| KernelSU | **Requires testing** | Uses Magisk-style scripts; not verified by the author |
| APatch | **Requires testing** | Uses Magisk-style scripts; not verified by the author |
| WebUI host | KsuWebUI Standalone | Required; the app itself supports Magisk / KernelSU / APatch |
| Other HyperOS 1.x/2.x devices | **Requires testing** | The code only checks package names; no device-specific lock |
| Other Android versions | **Requires testing** | `pm` syntax may differ |
| AOSP-like ROMs | Expected no-op | Candidate Xiaomi packages will not be found; not separately tested |

## Installation

1. Download `hyperos-debloater.zip` from [Releases](https://github.com/bellowname/hyperos-debloater/releases/latest).
2. Magisk → Modules → **Install from storage** → select the zip → reboot.
   For KernelSU / APatch the installation flow may differ and has not been verified by the author.
3. After boot, the default profile `safe` is applied automatically.
4. Optional: install [KsuWebUI Standalone](https://github.com/5ec1cff/KsuWebUIStandalone/releases) to use the graphical menu.

## Profiles

| Profile | What it disables | Risk |
|---|---|---|
| `safe` (default) | `com.miui.analytics`, `com.miui.systemAdSolution`, `com.miui.msa.global`, `com.miui.yellowpage`, `com.miui.bugreport` | Minimal: ads, analytics, Yellow Page, bug reports |
| `balanced` | Everything from `safe` plus browser, GetApps/store, Xiaomi Shop, Mi Video, Miracast, QR scanner, hybrid services | Medium: built-in apps you may actually use will stop working |
| `aggressive` | Everything from `balanced` plus Joyose, Discover, AOD, wallpapers, voice assistant, powerkeeper, luckymoney, game booster | Higher: game profiles, AOD and some Xiaomi features may disappear |

Missing packages are skipped. Use the scanner before choosing a stronger profile.

## WebUI

Magisk has no built-in WebUI renderer. The module ships a local `webroot/index.html`; open it with **KsuWebUI Standalone** by 5ec1cff.

1. Install KsuWebUI Standalone from its releases page.
2. Grant root when asked.
3. Open **HyperOS Debloater** in the module list.

In the WebUI you can switch profiles, toggle individual packages, add/remove whitelist entries, enable dry-run, run the scanner and read the log. Choices made there are saved to `custom.txt` and survive reboot.

## Dry-run

Create the marker file and apply the profile — nothing will be disabled, only logged:

```sh
su -c 'touch /data/adb/hyperos_debloater/dry-run'
su -c 'sh /data/adb/modules/hyperos_debloater/scripts/apply.sh'
cat /data/adb/hyperos_debloater/log.txt | grep DRY-RUN
```

Remove the marker to apply changes for real:

```sh
su -c 'rm /data/adb/hyperos_debloater/dry-run'
```

The same switch is available in WebUI.

## Rollback

- **Keeping the module:** WebUI → **Restore all** (press twice to confirm), or
  `su -c 'sh /data/adb/modules/hyperos_debloater/scripts/restore.sh'`.
- **Removing the module:** uninstall it in Magisk. `uninstall.sh` re-enables packages listed in `applied.txt` and `custom.txt`.
- **Cannot boot:** boot into recovery and delete `/data/adb/modules/hyperos_debloater`. Then remove the marker files in `/data/adb/hyperos_debloater` if needed.

## FAQ / troubleshooting

**An app disappeared.** It was probably disabled by a profile. Check `applied.txt`, add the package to `whitelist.txt` (or tap ★ in WebUI), then run `restore.sh`.

**Bootloop.** Disable/uninstall the module from recovery by deleting its directory. Do not flash aggressive profiles on an untested device.

**OTA update.** Disabled package state may be reset by an OTA; availability after OTA has not been tested. After updating, check `log.txt` and re-apply the profile if needed.

**SafetyNet / Play Integrity.** This module does not hide root and does not claim to fix Play Integrity. No tests were performed.

**HyperOS 2 / `DISABLE FAIL`.** Install v1.1.1 or newer: it waits for PackageManager, retries and logs the real error. If the line `PM DISABLE FAIL ...` remains, open an issue with that exact line and your scan report.

**Non-Xiaomi ROM.** The code looks for specific Xiaomi package names and skips what is missing. No device-specific magic is used; behavior is expected to be a no-op but not separately tested.

## Screenshots to add

See [docs/SCREENSHOTS.md](docs/SCREENSHOTS.md) for the capture checklist.

Currently available:

1. `docs/screenshots/webui.jpg` — **WebUI main screen: profile cards, package list and toggles**.

Useful next captures (not yet available):

2. Dry-run enabled + `DRY-RUN disable ...` lines in `log.txt`.
3. Scanner report in `/sdcard/Download/hyperos-debloater-packages.txt`.
4. WebUI after **Restore all** with the log showing `RESTORE`.
5. Magisk module page with the **Action** button visible.

## License and disclaimer

MIT — see [LICENSE](LICENSE). Security reports: [SECURITY.md](SECURITY.md). Contributions: [CONTRIBUTING.md](CONTRIBUTING.md).

**Make a backup and use dry-run first.** This module changes system package states. The author is not responsible for data loss, boot failures, OTA problems, unavailable apps, payment/banking app issues, warranty claims, Play Integrity results or any other consequences of use. It is open source: read the code before installing.
