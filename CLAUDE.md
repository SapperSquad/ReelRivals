# Reel Rivals — working notes

Competitive-fishing **data pack for vanilla Minecraft**. No mod loader, no Java, no Node, no Python.
The entire toolchain is Windows PowerShell 5.1. Published on Modrinth as SapperSquad.

**Current release: 1.4.1** ("Wider Waters") — LIVE on Modrinth and CurseForge since 2026-08-09.
Modrinth version ids `oljTTQsG` (1.21.1 zip), `Kk9uEOcy` (the 1.21.10-26.2 range zip) and
`RXfhUhHI` (NeoForge jar). **Project coverage went 3 -> 8 game versions.** The
`set_custom_model_data` bug that shipped in 1.4.0's 26.2 build is fixed in this release.

## Layout

| Path | What it is |
|---|---|
| `datapack/` | **Source of truth.** 1.21.1, pack_format 48. 85 `.mcfunction`, 166 files total. |
| `datapack-26x/` | **Generated — never hand-edit.** 26.2, pack_format 107. Output of `port_to_26.ps1`. |
| `dist/` | Built release artifacts: a `.zip` per MC line, plus a NeoForge `.jar` for 1.21.1. |
| `tools/` | Build, port, publish, book generator, card generator, RCON test harness. |
| `assets/` | Modrinth project art (icon, banner, gallery cards). |
| `promo/` | Larger promo renders (1920x640 banner, 512 icon, 5 gallery images). |
| `tools/vanilla-server/`, `vanilla-server-26/` | Local dedicated test servers, RCON preconfigured, pack pre-installed. |

Namespace is `reelrivals`. The one vanilla override is
`data/minecraft/loot_table/gameplay/fishing/fish.json` — that's what makes catches weighed, and it's
the only file another pack can collide with.

**Build artifacts** (all from `build.ps1`): the `.zip`s are loader-agnostic datapacks (vanilla,
Fabric, Quilt, NeoForge, Paper). The 1.21.1 line also produces `ReelRivals-<v>+mc1.21.1-neoforge.jar`
— a **code-free `lowcodefml` datapack-in-jar**: same `datapack/` contents plus a generated
`META-INF/neoforge.mods.toml` (version tracks `-Version`, so it can't drift). It installs like a mod
and loads after vanilla automatically, sidestepping the pack-order footgun the zip's install steps
warn about. It reuses the same raw-ZipArchive writer (`Write-PackArchive`), so the
forward-slash-entry rule applies to it too.

**Live-verified on a NeoForge server 2026-08-09** (Forgework's `gradlew runServer` rig, alongside
Forgework + PhytoForge, with the world datapack removed so only the jar could supply content):
NeoForge's mod list shows `Reel Rivals 1.4.0 (reelrivals)`, `load.mcfunction` ran (objectives set,
a bounty was active), the full weigh pipeline worked, and — the decisive check — rolling
`minecraft:gameplay/fishing/fish` produced an item carrying `reelrivals` custom_data, proving the
**jar wins the vanilla loot override**. `publish.ps1` uploads it as its own Modrinth version under
loader `neoforge`; use `-JarOnly` to catch the jar up to an already-published release without
duplicating the zip versions (`-SkipJar` is the inverse).

**Test-rig gotcha:** a backgrounded dev server gets EOF on stdin and shuts itself down after a few
seconds. Hold it open with `sleep 400 | ./gradlew.bat runServer`. Also, RCON executes at world
spawn — a `distance=` selector needs wrapping in `execute positioned <x y z> run ...` or it measures
from spawn and finds nothing.

## The release loop

Edit `datapack/` only, then:

```powershell
powershell -ExecutionPolicy Bypass -File tools\port_to_26.ps1     # regenerate datapack-26x/
powershell -ExecutionPolicy Bypass -File tools\build.ps1 -Version 1.2.2
powershell -ExecutionPolicy Bypass -File tools\publish.ps1 -Version 1.2.2 -ChangelogFile tools\changelog-current.md -DryRun
```

`publish.ps1` without `-DryRun` performs **real public uploads**. Always dry-run first, and get
SapperSquad's explicit go-ahead before a live publish.

- Modrinth project id: `kjZva5Zm` (the API needs the base62 id, not the `reel-rivals` slug).
- CurseForge needs a **numeric** project id, from `-CurseForgeProjectId <n>` or the
  `CURSEFORGE_PROJECT_ID` env var. Without one the script prints `CurseForge: SKIPPED` and uploads
  Modrinth only — check for that line before calling a release two-platform. **1.3.0 went to Modrinth
  only** for this reason.
- Tokens come from `MODRINTH_TOKEN` / `CURSEFORGE_TOKEN` env vars, never committed.
- **Two token traps, both hit on 2026-08-09:**
  1. `setx` only affects NEW processes. An agent shell started earlier keeps the OLD value and will
     fail auth with a perfectly good token. Read the live one from the registry instead:
     `$env:MODRINTH_TOKEN = (Get-ItemProperty HKCU:\Environment -Name MODRINTH_TOKEN).MODRINTH_TOKEN`
  2. **Don't health-check a Modrinth PAT with `GET /v2/user`** — that needs a *user-read* scope, and
     the publish token only needs **Create versions**. A 401 there says nothing about whether it can
     publish. There is no clean read-only probe for the create-version scope; just run the publish.
     Failures are safe — auth is rejected before any file transfer, leaving no partial upload.
- `-DryRun` resolves CurseForge game-version ids for real (read-only GET). Watch for `DID NOT RESOLVE`.
- **CurseForge throws transient HTTP 500s** ("An unhandled exception occurred") on `upload-file` with
  a request that is otherwise perfectly valid. Seen 2026-08-09: first attempt 500'd, an identical
  retry minutes later succeeded. **Before retrying, check the project's Files page** — a 500 gives no
  guarantee nothing was written, and a blind retry can double-upload. Empty Files page = safe to retry.
- CurseForge's `modloader` taxonomy has **no "Data Pack" entry** (only Forge/Fabric/Rift/Quilt/
  Risugami's/NeoForge/Flint), so a datapack upload sends the Minecraft version id alone. That is
  correct, not an omission — don't "fix" it by adding a loader tag.

### CurseForge version-id taxonomy (verified 2026-07-19)

Both targets resolve, but **each version string exists under several `gameVersionTypeID`s** and only
one is correct:

| Version | id | typeId | type name |
|---|---|---|---|
| 1.21.1 | **11779** | 77784 | Minecraft 1.21 — correct |
| 1.21.1 | 12735 | 1 | not listed in `/game/version-types` |
| 1.21.1 | 16115 | 615 | Addons (Bukkit taxonomy) — wrong |
| 26.2 | **16498** | 86297 | 26.2 — correct |
| 26.2 | 16500 | 1 | not listed |

`Get-CurseForgeGameVersionId` used to `Select-Object -First 1`, which returned the right id purely
because of response ordering — a reorder would have silently tagged the release as an *Addon*. It now
filters to version-types whose slug starts `minecraft-` and refuses to guess if none match. Don't
"simplify" that back.
- Uploads are **additive** — add new versions, don't delete old ones. Modrinth serves each player the
  newest file matching their game version.
- Update `tools/changelog-current.md` to the new version's notes before publishing; it's the body
  that gets posted.

### Multi-version findings (empirical, 2026-08-09)

Tested live on a real **1.21.11** Fabric server (Pantrywork's rig at
`Pantrywork/tools/fabric-server-12111`, RCON pw `pantrywork`):

- **The 26.x content tree runs unmodified on 1.21.11.** The fishing loot override applies, the weigh
  pipeline bakes `w` + lore, `time_check` with `"clock":"minecraft:overworld"` is accepted (Midnight
  Eel and Moonlit Koi both rolled at midnight), and the bounty system runs. Only `pack.mcmeta`
  differs. This is what makes cheap version expansion possible.
- **pack.mcmeta format rule:** a pack declaring support beyond format **81** MUST use `min_format` /
  `max_format`; `supported_formats` alone is rejected with *"declares support for version newer than
  81, but is missing mandatory fields min_format and max_format"*. At or below 81, `supported_formats`
  is fine. So the pre-26 range and the 26.x range need different metadata spellings.
- **BUG FOUND AND FIXED — shipped broken in 1.4.0's 26.2 build.** Loot tables set model ids with
  `{ "function": "minecraft:set_custom_model_data", "value": 790002 }`. On 26.x/1.21.11 that still
  *parses* but silently produces an **empty** component, so all 24 custom species lost their model id
  and no resource pack could re-skin them. Verified by experiment:
  | form | result |
  |---|---|
  | `"floats":[790002]` | table fails to parse |
  | `"floats":{"mode":"replace_all","values":[790002]}` | `{floats:[790002.0f]}` — correct |
  | `"value":790002` | `{}` — silent no-op |
  `port_to_26.ps1` rule 2b now rewrites it. **The live 26.2 downloads still have this bug** until a
  rebuild ships. Gameplay is unaffected (cosmetic/resource-pack only), but the README's "a resource
  pack can re-skin them later" claim is false on 26.x until then.
- **Still unknown:** the authoritative `pack_format` numbers for 1.21.5-1.21.11. Needed before
  shipping a mid-range artifact - do not guess them; a wrong number means the pack silently refuses
  to load.

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
`promo/gallery-5-endgame.png`, `promo/gallery-6-bounty.png` (1.4.0), `assets/card_progression.png`,
and `assets/card_market.png` (1.4.0). **The other images in `assets/` and `promo/` are still
source-less hand-made exports from 1.1.0** — `assets/banner.png` (the pixel-art one), `icon`,
`card_species`, `card_lures`, `card_tournaments`, and galleries 1-3. If one of those needs a content
change, port it into `GenCards.java` rather than editing the PNG, so it stops being a dead end.

Shared drawing helpers worth reusing: `panel`, `headline` (yellow slab under the first N chars),
`eyebrow`, `paragraph` (word-wrap, returns next y), `centered`, `star`, `emerald`, `ledger`,
`rod`, `fishSilhouette`, and `fitWidth` (scales type to a target width — **more tracking means a
smaller font at fixed width**). Gallery cards are 1280x720 on `galleryBackground`; `assets/card_*`
are 1280x640 on the flat `CARD_TOP`→`CARD_BOTTOM` gradient with `pixelWaves` at the foot.

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

## 1.4.0 systems (bounty / market / log)

Spec + rationale: `DESIGN-1.4.0.md`. Key facts:

- **Weight is now ON the item.** `apply_weight` bakes `custom_data.reelrivals.w` (0.1-kg units)
  alongside the lore, fed from `weigh.mcfunction`'s `reelrivals:tmp`. This is what the market prices
  from — and the hook a future economy mod would read. **Fish caught pre-1.4.0 have no `w`** and fall
  through to the 1-emerald floor; that's intended, not a bug.
- **Bounty** rotates on **in-game days** (`#bperiod`, default 7) because vanilla has no wall-clock
  query — never call it "weekly" in player-facing copy. `bounty/rotate` (throttled to ~1/sec in tick,
  plus once from load) decides; `bounty/roll` picks 1..28, bumps on an immediate repeat, clears
  `rr_bounty_claimed` tags, stamps `#bstart`. `bounty/hit` fires from `catch/score`; `bounty/claim`
  is the once-per-rotation 16-emerald reward.
- **Market** has two paths on purpose: `market/sell_held` reads `SelectedItem` (unambiguous) and
  prices by weight; `market/sell_all` uses `clear @s <pred> 0` to COUNT then `clear` to remove — no
  inventory iteration, provably correct. Flat 2 em/fish is a deliberate convenience discount.
- **Trophies and the Almanac can't be sold** — they carry `trophy:`/`guide:`, not `weighed:1b`.
- Tunables live in `load.mcfunction` and are `add`-then-conditionally-set, so an admin's live change
  survives `/reload`.

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
