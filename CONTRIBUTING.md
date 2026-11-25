# Contributing

Thanks for helping. Please keep changes small, factual and reversible.

## What is most useful

1. **Package reports.** Run the scanner and attach its report to an issue:
   `su -c 'sh /data/adb/modules/hyperos_debloater/scripts/scan.sh'`
   Report: `/sdcard/Download/hyperos-debloater-packages.txt`.
2. **Region profiles.** Global, EEA, CN and RU builds use different package names.
   Describe exactly which packages you tested and what stopped working.
3. **Documentation fixes.** Typos, clearer rollback steps, compatibility reports.

## Rules

- Do not add network requests, telemetry or remote configuration.
- Do not propose deleting system APKs. This project only disables packages.
- Do not claim performance or battery gains without benchmarks.
- Any new package must include: name, purpose, risk, tested ROM/region.
- Risky packages belong only in `aggressive`.
- Preserve backward compatibility for users on `safe`.

## Before opening a PR

```sh
sh -n module/*.sh module/scripts/*.sh scripts/*.sh
sh scripts/build.sh
```

If you edited the WebUI, also check the inline JavaScript syntax.

Commit message examples:

```text
docs: clarify rollback steps
profiles: add EEA browser package
scripts: make pm enable fallback explicit
```

## Compatibility reports

KernelSU and APatch are currently marked as unverified. If you test them, open an issue
with: manager version, Android version, module version and whether Action/WebUI worked.
That evidence lets us update the support table honestly.

## License

By contributing you agree that your changes are licensed under MIT, same as the project.
