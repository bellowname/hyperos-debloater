## What's changed

- <!-- One factual bullet per change. No performance claims. -->

## Safety notes

- Nothing is deleted: packages are disabled with `pm disable-user` and can be restored.
- Default profile is `safe`. Use dry-run before trying `balanced` or `aggressive`.
- Make a backup before installing any root module.

## Tested on

- Device: Redmi Note 12 (`tapas`)
- ROM: HyperOS 2.0.209.0, Global region (reported by the author)
- Android: 15
- Root manager: Magisk

## Not verified yet

- KernelSU, APatch
- Other Xiaomi models and HyperOS versions
- OTA upgrade behavior
- SafetyNet / Play Integrity (the module does not hide root)

## Install

Download `hyperos-debloater.zip` below, install it in Magisk, reboot, then open
[KsuWebUI Standalone](https://github.com/5ec1cff/KsuWebUIStandalone) for the WebUI.

## Rollback

Uninstall the module in Magisk: `uninstall.sh` re-enables everything this module
disabled. Inside the module, use WebUI → **Restore all** or `scripts/restore.sh`.

## Feedback

If the log contains `PM DISABLE FAIL ...`, open an issue with that exact line, your
`scan.sh` report, device, ROM and active profile.

**The author is not responsible for data loss, boot failures, OTA problems or any
other consequences. Read the code and README before installing.**
