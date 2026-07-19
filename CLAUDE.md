# Reel Rivals — working notes

Competitive-fishing **data pack for vanilla Minecraft**. No mod loader, no Java, no Node, no Python.
The entire toolchain is Windows PowerShell 5.1. Published on Modrinth as SapperSquad.

**Current release: 1.3.0** ("Two Paths"). `dist/` holds every built version through 1.3.0.

## Layout

| Path | What it is |
|---|---|
| `datapack/` | **Source of truth.** 1.21.1, pack_format 48. 85 `.mcfunction`, 166 files total. |
| `datapack-26x/` | **Generated — never hand-edit.** 26.2, pack_format 107. Output of `port_to_26.ps1`. |
| `dist/` | Built release zips, one per MC line per version. |
| `tools/` | Build, port, publish, book generator, card generator, RCON test harness. |
| `assets/` | Modrinth project art (icon, banner, gallery cards). |
| `promo/` | Larger promo renders (1920x640 banner, 512 icon, 5 gallery images). |
| `tools/vanilla-server/`, `vanilla-server-26/` | Local dedicated test servers, RCON preconfigured, pack pre-installed. |

Namespace is `reelrivals`. The one vanilla override is
`data/minecraft/loot_table/gameplay/fishing/fish.json` — that's what makes catches weighed, and it's
the only file another pack can collide with.

## The release loop

Edit `datapack/` only, then:

```powershell
powershell -ExecutionPolicy Bypass -File tools\port_to_26.ps1     # regenerate datapack-26x/
powershell -ExecutionPolicy Bypass -File tools\build.ps1 -Version 1.2.2
powershell -ExecutionPolicy Bypass -File tools\publish.ps1 -Version 1.2.2 -ChangelogFile tools\changelog-current.md -DryRun
```

`publish.ps1` without `-DryRun` performs **real public uploads**. Always dry-run first, and get
Alex's explicit go-ahead before a live publish.

- Modrinth project id: `kjZva5Zm` (the API needs the base62 id, not the `reel-rivals` slug).
- CurseForge needs a **numeric** project id, from `-CurseForgeProjectId <n>` or the
  `CURSEFORGE_PROJECT_ID` env var. Without one the script prints `CurseForge: SKIPPED` and uploads
  Modrinth only — check for that line before calling a release two-platform. **1.3.0 went to Modrinth
  only** for this reason.
- Tokens come from `MODRINTH_TOKEN` / `CURSEFORGE_TOKEN` env vars, never committed.
- `-DryRun` resolves CurseForge game-version ids for real. Watch for `DID NOT RESOLVE` — CurseForge's
  version list lags new Minecraft releases, so the 26.x build may have no valid target there yet even
  when 1.21.1 uploads fine.
- Uploads are **additive** — add new versions, don't delete old ones. Modrinth serves each player the
  newest file matching their game version.
- Update `tools/changelog-current.md` to the new version's notes before publishing; it's the body
  that gets posted.

### What port_to_26.ps1 actually transforms

pack_format 48→107 · `time_check` `period` → `clock:"minecraft:overworld"` · recipe ingredients to
plain strings · `custom_model_data` int → `{floats:[…]}` · `enchantments` flattened out of the
`levels` wrapper. Porting to a future MC version = teach this script that version's deltas (read them
from the server jar's `version.json` and generated `--reports`), then re-verify with the RCON suite.

## Promo art

`tools/GenCards.java` regenerates the cards whose content goes stale:

```powershell
java tools/GenCards.java     # Java 11+ single-file launch; writes promo/ and assets/ PNGs
```

It currently owns `promo/banner-1920x640.png`, `promo/gallery-4-gear.png`,
`promo/gallery-5-endgame.png`, and `assets/card_progression.png`. **The other images in
`assets/` and `promo/` are still source-less hand-made exports from 1.1.0** — `assets/banner.png`
(the pixel-art one), `icon`, `card_species`, `card_lures`, `card_tournaments`, and galleries 1-3.
If one of those needs a content change, port it into `GenCards.java` rather than editing the PNG,
so it stops being a dead end.

**The species count lives in `GenCards.SPECIES_COUNT` (28).** 28 = 24 custom species (one per
`lure_*.json`) + the vanilla four (cod, salmon, tropical, puffer), which are weighed and count
toward records but add no new fish. The 1.2.1 banner said "24 rare species," counting only the
custom ones — it contradicted the store page and undersold the pack. If species are ever added,
update that constant and `MC_VERSIONS`, then rerun. `card_species.png` and `gallery-2-species.png`
also say 28 but are still hand-made, so they need manual attention on any change.

Keep the file ASCII-only (same reason as the `.ps1` scripts) and note the `Color` gotcha:
`new Color(int, int)` is not a constructor — use the 4-arg `Color(r, g, b, a)` for alpha.

## Testing — do this after any pack change

Headless regression over RCON, no player needed. This loop caught every runtime bug during
development.

```powershell
cd tools\vanilla-server
java -Xmx2G -jar server.jar nogui        # RCON on 25575, password rrtest
# then, from tools\:
powershell -ExecutionPolicy Bypass -File rcon_cmd.ps1 -File smoketest.txt
```

Re-sync `vanilla-server/world/datapacks/ReelRivals` from `../datapack` before testing changes.
What to verify in the output is documented in `tools/README.md` — weighed items show
`weighed:1b, unweighed:0b`, lore carries exactly one `Weight: X.Y kg` line (a second process pass
must NOT add another), the record scoreboard matches the lore (record 51 = 5.1 kg), and lure
conversion renames the item and sets `#conv` to 1.

**Gotcha:** RCON commands run at world spawn with no chunks loaded. Entity tests silently fail in
unloaded chunks — `smoketest.txt` forceloads (0,0)..(24,24) and cleans up after itself.

## Environment gotchas (these have all bitten before)

- **PS 5.1 reads BOM-less `.ps1` as ANSI** → keep every script in `tools/` ASCII-only. Non-ASCII
  characters in a PowerShell file will corrupt.
- **`Compress-Archive` writes backslash zip entries**, which Minecraft's zip reader treats as literal
  filename characters — the pack enables but loads empty. `build.ps1` drops to raw
  `System.IO.Compression` with forward-slash entry names for exactly this reason. Don't "simplify" it.
- **`Get-Content` attaches hidden PSPath metadata** to returned strings, which `ConvertTo-Json` then
  serializes as a nested object instead of a plain string. Cast to `[string]` — see `publish.ps1`.
- Data files (`pack.mcmeta`, JSON) are **UTF-8 without BOM and should stay that way**. Reading them
  with plain `Get-Content` shows mojibake (`—` as `â€"`) — that's an artifact of the ANSI read, not
  corruption in the file. Verify with `[System.Text.Encoding]::UTF8.GetString([System.IO.File]::ReadAllBytes(...))`
  before "fixing" an em-dash.

## Doc accuracy

`README.md`, `CHANGELOG.md`, `PUBLISHING.md`, and `tools/README.md` are all current at **1.3.0**.
**Bump them together on every release**, along with `tools/changelog-current.md` (that file is the
body `publish.ps1` posts).

Ground truth for feature counts, since docs drift: `datapack/data/reelrivals/recipe/` has
`bait_1..5` (five bait tiers), six rods (`rod_angler|master|champion|legend|naturalist|grandmaster`),
and 24 `lure_*` recipes. Tournament options live in `function/tournament/menu.mcfunction`. The
Almanac's real page count is whatever `gen_book.ps1` prints when it runs — never trust prose for it.

## Rod progression (1.3.0)

Shared base, then two parallel tracks; both fully obtainable, no exclusivity state.

- **Shared**: Angler's (10 catches) -> Master's (50 catches or a 10 kg catch)
- **Naturalist track**: Naturalist's (the `reelrivals:naturalist` advancement - one catch in each of
  nine environments, via an OR-group `requirements` array) -> Legend (`master_angler=true` + the
  `rr_hw2` leviathan tag)
- **Circuit track**: Champion's (5 played or 1 win) -> Grandmaster's (5 wins, or 3 wins + 20 played)

The Naturalist's Rod fires from its advancement's `rewards.function`; every other unlock is a
per-tick selector check in `tick.mcfunction`. Unlock tags run `rr_u1`..`rr_u9`.

**Stat philosophy, so it doesn't get relitigated:** Luck of the Sea governs rarity, Lure governs
bite speed. Legend = LotS 8 / Lure 3 (rarity). Grandmaster's = LotS 7 / Lure 4 (speed). Verified in
the vanilla enchantment definitions pulled from `server.jar`: Lure reduces the wait by **5s per
level** off a 5-30s roll, so Lure 3 averages ~4.5s, Lure 4 ~2s, and Lure 5 ~0.5s. **Lure 5 was
rejected** — a ~9x catch rate would have made the AFK-farm problem in Most Catches mode far worse.
Over-max levels do not clamp (RCON-verified 2026-07-19).

## Design decisions already settled

- Buy-ins are **emeralds only** — fungible escrow makes refunds and splits trustworthy. Item wagering
  is house rules, deliberately not implemented.
- Biggest Catch is the default tournament mode because it's AFK-farm resistant. Most Catches is
  offered anyway; hosts are warned.
- Item text in 1.21.1 **cannot bake player names** (verified in testing) — trophies carry day + score,
  and the winner's name lives in the broadcast instead.
- No resource pack required. Custom fish reuse vanilla items with colored names, but everything
  carries `custom_model_data` (fish 790001+, bait 790201+, rods 790301+, trophies 790101+) so a pack
  can re-skin later without datapack changes.
- Known accepted edge case: two players reeling the same species within 12 blocks in the same tick can
  cross attribution. Rare, harmless outside photo finishes.

## Roadmap ideas (not started)

Moving hotspot markers with bubble particles and bonus loot · upgradeable fishing boats + fish-finder
GUI (would need a NeoForge companion mod) · Modrinth release as a datapack-in-jar.
