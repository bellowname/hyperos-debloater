# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Documentation-only improvements: English and Russian README restructure,
  repository metadata proposal, security policy, release notes template,
  announcement drafts and screenshot checklist.

## [1.1.1] - 2026-11-25

### Fixed

- `pm disable-user` failures at boot on HyperOS: the module now waits for
  PackageManager, retries with a pause and falls back to `pm disable`.
- `RESTORE FAIL` / "Восстановлено пакетов: 0": `pm enable` now uses explicit
  `--user 0` with a fallback.
- Real `pm` errors are logged as `PM DISABLE FAIL ...` instead of a bare `FAIL`.

### Added

- English README; Russian version moved to `README_RU.md`.
- WebUI screenshot in `docs/screenshots/webui.jpg`.

## [1.1.0] - 2026-11-25

### Added

- WebUI for Magisk / KernelSU / APatch via KsuWebUI Standalone: profile switch,
  package toggles, whitelist, dry-run, log and scanner.
- `custom.txt` for manual toggles that survive reboot.
- Enabling a package in WebUI adds it to `whitelist.txt`.
- `uninstall.sh` also restores packages disabled manually in WebUI.
- GitHub Actions workflow with zip build and release attachment.

### Changed

- Build script sets `0755` on `.sh` files and `0644` on other files.
- Workflow has `contents: write` permission for release assets.

## [1.0.0] - 2026-11-25

### Added

- Initial release.
- Three profiles: `safe`, `balanced`, `aggressive`.
- Whitelist of critical packages.
- Dry-run marker and action log.
- Scanner script and automatic restore on uninstall.

[Unreleased]: https://github.com/bellowname/hyperos-debloater/compare/v1.1.1...HEAD
[1.1.1]: https://github.com/bellowname/hyperos-debloater/releases/tag/v1.1.1
[1.1.0]: https://github.com/bellowname/hyperos-debloater/releases/tag/v1.1.0
[1.0.0]: https://github.com/bellowname/hyperos-debloater/releases/tag/v1.0.0
