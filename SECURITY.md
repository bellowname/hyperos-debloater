# Security policy

## Supported versions

| Version | Supported |
|---|---|
| 1.1.x | ✅ |
| 1.0.x | ❌ (no fixes, upgrade recommended) |

## Threat model

The module runs as root and executes shell scripts at boot. It does not make network
requests, does not collect telemetry and does not modify `/system`. The WebUI is a
local page; `scripts/webui.sh` accepts only fixed commands and package names matching
a strict pattern.

This is still a root module: install only from trusted sources and read the code.

## Where to report

- **Ordinary bugs and feature requests:** GitHub **Issues** on this repository. Use the
  bug report or feature request template and attach `log.txt` / `scan.sh` output.
- **Suspected vulnerabilities:** GitHub's private vulnerability reporting
  (**Security → Report a vulnerability**) if it is available. No public email address
  is published for this project.

Please **do not** post a working exploit publicly. If private reporting is unavailable,
open a minimal issue titled `[Security] ...` with a short description **without
reproduction steps** and wait for a maintainer reply. Include: module version, root
solution, device/ROM, and which file or command is affected.

Expected response time: best effort, usually within a few days.

## Out of scope

- Root detection, SafetyNet / Play Integrity behavior — the module does not hide root.
- Bugs in Magisk, KernelSU, APatch or KsuWebUI Standalone — report them upstream.
- Damage caused by disabling a package that was in a profile but was needed by the user:
  whitelist and rollback are provided, but configuration mistakes are the user's responsibility.
