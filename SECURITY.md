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

## Reporting a vulnerability

Please **do not** post a working exploit publicly.

1. Use GitHub's private vulnerability reporting on this repository
   (**Security → Report a vulnerability**) if it is available.
2. If it is not available, open a minimal issue titled `[Security] ...` with a short
   description **without reproduction steps** and wait for a maintainer reply.
3. Include: module version, root solution, device/ROM, and which file or command is affected.

Expected response time: best effort, usually within a few days.

## Out of scope

- Root detection, SafetyNet / Play Integrity behavior — the module does not hide root.
- Bugs in Magisk, KernelSU, APatch or KsuWebUI Standalone — report them upstream.
- Damage caused by disabling a package that was in a profile but was needed by the user:
  whitelist and rollback are provided, but configuration mistakes are the user's responsibility.
