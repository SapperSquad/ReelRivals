# Reel Rivals test harness

Headless regression testing over RCON — no player needed. This is the loop that caught every
runtime bug during development (2026-07-18); run it after any pack change or Minecraft version port.

## Setup

1. In the test server's `server.properties`:
   ```
   enable-rcon=true
   rcon.port=25575
   rcon.password=rrtest
   ```
2. Install the pack in the server world's `datapacks` folder and start the server.
   A ready-to-use **official vanilla 1.21.1 server** lives in `vanilla-server/` (RCON
   preconfigured, pack pre-installed in `world/datapacks/ReelRivals` — re-sync it from
   `../datapack` after changes). Start it with:
   ```
   cd vanilla-server
   java -Xmx2G -jar server.jar nogui
   ```
   The NeoForge dev server (`gradlew runServer` in Forgework) also works for modded-compat runs.
   Full suite passed on both on 2026-07-18.

## Run

```powershell
powershell -ExecutionPolicy Bypass -File rcon_cmd.ps1 -File smoketest.txt
```

Each command prints with its server response. What to check:

- weighed item custom_data shows `weighed:1b, unweighed:0b`
- lore shows one literal `Weight: X.Y kg` line, and the second process pass does NOT add another
- the record scoreboard matches the lore (record 51 = 5.1 kg)
- lure conversion renames the item and sets `#conv` to 1
- the Almanac spawns with `enchantment_glint_override` = `0b` and pages[19] exists (20 pages)

The cleanup block at the end of `smoketest.txt` resets the record slates it touched.
Edit or extend `smoketest.txt` freely — one command per line, `#` for comments.

## Notes

- Commands run at world spawn with no chunks loaded unless forceloaded — the smoke test
  forceloads (0,0)..(24,24) and cleans up after itself. Entity tests silently fail in
  unloaded chunks.
- To watch a live tournament countdown, set `#state`/`#ticks`/`#mode` scoreboard values
  directly (see the tournament functions) — the tick loop runs it in real time.
- Keep this ASCII-only gotcha in mind when editing PowerShell here: PS 5.1 reads BOM-less
  .ps1 files as ANSI, so avoid non-ASCII characters in scripts.
