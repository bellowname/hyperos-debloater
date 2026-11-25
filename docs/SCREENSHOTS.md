# Screenshot checklist

Goal: a new visitor should understand the module in 30 seconds. Do not fake or doctor
screenshots; redact IMEI/accounts if visible.

## Already available

1. **WebUI main screen** — `docs/screenshots/webui.jpg`
   Caption: "Profiles, package list and toggles in KsuWebUI Standalone."

## Still needed

2. **Dry-run proof**
   Capture `/data/adb/hyperos_debloater/log.txt` with lines containing
   `DRY-RUN disable ...`.
   Caption: "Dry-run: the module logs what it would disable without changing anything."

3. **Scanner report**
   Capture `/sdcard/Download/hyperos-debloater-packages.txt` after `scan.sh`.
   Caption: "Scanner shows which known packages actually exist on this firmware."

4. **Restore proof**
   Capture the WebUI log or `log.txt` after **Restore all** with `RESTORE ...` lines.
   Caption: "Uninstall or Restore all re-enables only what this module disabled."

5. **Root manager entry**
   Capture the Magisk module page with the **Action** button visible.
   Caption: "Action cycles safe → balanced → aggressive without terminal commands."

## Notes

- Keep images under ~500 KB where possible; PNG for text, JPEG for UI.
- Do not include personal data, serial numbers or active account names.
- Add images to `docs/screenshots/` and reference them from both README files.
