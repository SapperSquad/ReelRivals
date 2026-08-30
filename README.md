# Reel Rivals

Competitive fishing for **vanilla Minecraft 1.21.1** (pack_format 48). Every fish you reel in gets a rolled
weight engraved on it. Rare species spawn by biome, weather, and time of day. Server records are tracked and
announced. Anyone can host a buy-in tournament — no ops required, everything runs off `/trigger`.

## Versions

Two builds, same content, one per Minecraft data-format line. `tools/build.ps1` produces both:

| Build | Minecraft | Source tree | datapack format |
|---|---|---|---|
| `dist/ReelRivals-1.4.0+mc1.21.1.zip` | 1.21.1 | `datapack/` (the source of truth) | 48 |
| `dist/ReelRivals-1.4.0+mc1.21.1-neoforge.jar` | 1.21.1 | same, wrapped as a code-free mod | 48 |
| `dist/ReelRivals-1.4.0+mc26.2.zip` | 26.2 | `datapack-26x/` (generated) | 107 |

The `.zip`s are loader-agnostic — vanilla, Fabric, Quilt, NeoForge, and Paper all load a datapack
the same way. The `.jar` is the same content wrapped as a code-free NeoForge mod, so it installs
like a mod and always loads after vanilla (no pack-order fiddling).

The 26.x build is **generated, never hand-edited** — `tools/port_to_26.ps1` transforms the 1.21.1
tree into `datapack-26x/` (pack format 48→107; `time_check` `period`→`clock:"minecraft:overworld"`;
recipe ingredients to plain strings; `custom_model_data` int→`{floats:[…]}`; `enchantments` flattened
out of the `levels` wrapper). To update: edit `datapack/`, then run `port_to_26.ps1` and `build.ps1`.
Porting to a future version = teach `port_to_26.ps1` that version's format deltas (read them from the
server jar's `version.json` and generated `--reports`), then re-verify with `tools/`.

## Install

1. Drop the release **zip as-is** (don't extract it) into your world's `datapacks` folder — or copy the
   `datapack` folder in and rename it `ReelRivals`.
2. `/reload` (or re-enter the world). You'll see the load message.
3. **If fishing gives plain, weightless fish**: the pack must load AFTER vanilla to override the fishing
   loot table (pack order matters — later wins). Fix it in-game:
   `/datapack disable "file/<packname>"` then `/datapack enable "file/<packname>" last`.
   The pack self-checks on join and warns you in chat if another pack is overriding its fishing loot.
4. Optional but recommended for gear gating: `/gamerule doLimitedCrafting true`
   (without it, players who look up the recipes can craft rods before unlocking them).

No resource pack required — custom fish reuse vanilla fish items with colored names. All custom items carry
`custom_model_data` values (fish 790001+, bait 790201+, rods 790301+, trophies 790101+) so a resource pack
can re-skin them later without touching the datapack.

## Player commands

| Command | What it does |
|---|---|
| `/trigger rr.help` | Quick how-to |
| `/trigger rr.host` | Host a tournament — clickable chat menu for scoring, target, duration, buy-in, gear rules, payout split |
| `/trigger rr.join` | Join an open lobby (pays the emerald buy-in into the pot) |
| `/trigger rr.records` | Server record ledger — best weight per species, who holds it, and the in-game day |
| `/trigger rr.stats` | Your **Angler's Log** — lifetime catches, personal-best weight, tournaments played/won, bounties claimed, emeralds earned, and rods earned |
| `/trigger rr.market` | Sell the fish in your hand for emeralds, priced by its exact weight (bounty species pays 2×) |
| `/trigger rr.sellall` | Sell every weighed fish at once at a flat rate — fast, with a small convenience discount |
| `/trigger rr.top` | Toggle the **Top Anglers** sidebar — a live leaderboard of lifetime catches (top ~15, sorted, offline players included). Auto-hides during tournaments (the sidebar shows live standings then). |
| `/trigger rr.guide` | Get the **Angler's Almanac** — 30-page field guide (fish + conditions, lure recipes, both rod build paths, tournament commands). No enchant glint, two-page clickable table of contents, and a `<< Contents` link in every page footer. Also auto-given to each player on first join. Note: books already in inventories are snapshots — grab a fresh copy after updating the pack. |

Admin: `/function reelrivals:admin/reset` force-cancels a stuck tournament and refunds buy-ins.

## Systems

- **Weighed catches** — every fished item rolls a weight (shown as `X.Y kg` in lore) and flashes on your
  actionbar the moment you reel it in, with your updated score during a tournament. Weights drive records,
  the Heavyweight milestone (10 kg+), and tournament scoring.
- **28 species by environment**:
  - *Rivers*: Golden Bass, Copper Trout, Whiskered Catfish, Mudskip Gar (night)
  - *Lakes & ponds* (freshwater that isn't river/swamp/jungle/frozen): Lake Perch, Mirror Carp, Moonlit Koi (night)
  - *Oceans*: Silver Herring, Sunfin Tuna (day), Storm Marlin (rain), **Thunderfin (thunderstorms only)**,
    Ember Snapper (warm), Coral Empress (warm + day, rare), Frostfin Char (frozen), Glacier Pike (frozen + night),
    Deep Grouper (deep), Abyssal Angler (deep + night, rare), **Ancient Coelacanth (deep, near-myth, up to 20 kg)**
  - *Swamps*: Swamp Lurker — *Jungles*: Jungle Piranha, Emperor Arowana (rare) — *The End*: **Void Skate**
    (place your own water!) — *Anywhere*: Midnight Eel (night), the vanilla four, and the luck-gated
    **King Sturgeon** (up to 25 kg, very rare)
- **Targeted lures** — catch a species once naturally and you learn its lure recipe (toast + chat unlock).
  Craft it (slime ball + string + a thematic ingredient), **hold it in your offhand while fishing**, and 35% of
  common catches in the right environment convert to your target (consuming one lure per success). The
  condition-breaker lures ignore time/weather: **Nightcrawler** (Midnight Eel, any hour), **Moon Popper**
  (Moonlit Koi, any hour), **Storm Jig** (Storm Marlin, no rain needed), **Sunfin Spoon** (Sunfin Tuna, any
  hour), **Abyssal Beacon** (Abyssal Angler, any hour, 20%). **King's Roe** (heart of the sea + golden apple)
  tempts the King Sturgeon anywhere at 10%.
- **Bait** — five tiers of consumable Luck buffs; Luck feeds the vanilla fishing `quality` system.
  First catch → Bait Tin I; 10 catches → Bait Tin II; 50 catches *or* a 10 kg catch → Bait Tin III;
  100 catches → Abyssal Chum (Tin IV, Luck IV); 500 catches → King's Feast (Tin V, Luck V, 8 min —
  makes the quality-4 legends realistically huntable). Bait (Luck) and lures (targeting) stack — bait
  raises rare bites, lures convert the boring ones.
- **Rods — two paths.** Everyone walks the same first two rungs, then the ladder forks. Both paths are
  fully obtainable; nothing locks you out of the other.

  | | Rod | Enchants | Unlock |
  |---|---|---|---|
  | *shared* | Angler's Rod | Lure II, LotS II | 10 catches |
  | *shared* | Master's Rod | Lure III, LotS IV, Unbreaking III | 50 catches *or* a 10 kg catch |
  | **Naturalist** | Naturalist's Rod | Lure III, LotS VI, unbreakable | A catch in all nine waters |
  | **Naturalist** | Legend Rod | Lure III, **LotS VIII**, unbreakable | Every species on the ledger + a 15 kg catch |
  | **Circuit** | Champion's Rod | Lure III, LotS VI, unbreakable | 5 tournaments *or* 1 win |
  | **Circuit** | Grandmaster's Rod | **Lure IV**, LotS VII, unbreakable | 5 wins, *or* 3 wins + 20 played |

  The two capstones spend the same power budget differently. Luck of the Sea governs rarity, Lure governs
  bite speed — so the Legend Rod is the rod you hunt legends with, and the Grandmaster's Rod fishes about
  twice as fast for the modes where volume wins. The **nine waters** for the Naturalist's Rod are rivers,
  lakes, the open ocean, warm seas, frozen seas, the deeps, swamps, jungles, and the End.
- **The long grind** (late game): a 15 kg catch → *Leviathan* · 1000 catches → *Master of the Deep*:
  server-wide broadcast and a unique keepsake trophy.
- **Tournaments** — the host picks six settings from a clickable chat menu:
  - **Scoring**: Total Weight / Biggest Catch / Most Catches
  - **Target**: Any / Rivers & Lakes (freshwater only) / Ocean (saltwater only) / Trophy Hunt (rare and
    legendary species only)
  - **Duration**: 5 / 10 / 15 minutes
  - **Buy-in**: Free, or 1 / 2 / 4 / 8 / 16 / 32 / 64 emeralds
  - **Gear**: Any Rod / **Fair Play** (no Luck of the Sea — everyone on even rods) / **Pro League**
    (Luck of the Sea IV+ required)
  - **Payout**: winner-takes-all or 60/30/10

  Then: 60-second join window, bossbar countdown, sidebar live standings, per-catch score updates on the
  actionbar, a 45-second **Feeding Frenzy** (+25% weight) at the halfway mark, ranked results, automatic pot
  payout, and engraved Gold/Silver/Bronze trophies (winner name, in-game day, final score).
  Payouts queue in a ledger and auto-deliver when the recipient is online, so a crash or logout can't eat the pot.
  Trophies are baked with the tournament day and final score; the winner's name is immortalized in the results
  broadcast and the record announcements (item text in 1.21.1 can't bake player names — verified in testing).
- **The Bounty Board** — there is always an active bounty species. Land it and you claim **16 emeralds**
  (once per rotation, per player), and it sells for **double** at the market until the bounty rotates.
  The target rerolls every **7 in-game days** and never repeats twice in a row, with a server-wide
  announcement each time. *(Vanilla has no wall-clock query, so the period is in-game days, not real
  weeks — admins can raise `#bperiod` for a slower rotation.)*
- **The Fish Market** — cash your catch out for emeralds. `/trigger rr.market` sells the fish in your
  hand **priced by its exact weight** (floor of kg, minimum 1 — so a 25 kg King Sturgeon pays 25 and a
  minnow pays 1), doubled if it's the bounty species. `/trigger rr.sellall` clears your whole catch at a
  flat 2 emeralds each: faster, slightly worse, so trophies are worth selling by hand. Admins tune the
  rate with `#emper` (kg per emerald). Trophies and the Almanac are never sellable.
- **The Angler's Log** — `/trigger rr.stats` gives each player their own numbers: lifetime catches,
  personal-best weight, tournaments played and won, bounties claimed, emeralds earned at market, and
  which rods they've earned.
- **Advancements** — On the Scale, The Old King, Master Angler (catch all 28), Every Water in the World
  (a catch in all nine environments), Grandmaster, Regular at the Docks, Heavyweight, Circuit Regular,
  Tournament Champion, plus hidden per-species catches that unlock each lure.

## Design notes / anti-cheese

- Biggest Catch is the default mode and AFK-farm resistant; Most Catches is offered but hosts should know AFK
  farms can grind it.
- Buy-ins are emeralds only, by design — fungible escrow makes refunds and splits trustworthy. Wagering items
  is left to house rules.
- Ties break by whoever the ranking pass finds first (effectively arbitrary); dead-even scores are rare with
  weight-based modes.
- Catches are attributed to the player who actually reeled in (an 8-tick window opened by the rod's hook
  event), not whoever stands nearest the bobber — this was the "catch theft" bug fixed in 1.2.0. A
  nearest-player fallback still exists for catches whose reel window has expired, so in a dense crowd of
  anglers a stray catch can theoretically cross over. Rare, and harmless outside photo finishes.

## First-load test checklist

1. `/reload` → load message appears, no errors in the log.
2. Fish anything → item lore shows `Weight: X.Y kg`, the actionbar names the species and weight, and the
   first catch grants **On the Scale** + the Bait Tin I recipe.
3. Beat a record → server-wide record broadcast; `/trigger rr.records` shows it with your name on it.
4. `/trigger rr.host` → menu clicks respond; open lobby with 2 players (or use a second account); verify
   emeralds are taken, the countdown bossbar runs, and payouts + trophies land at the end.
5. **Target/gear rules**: host a Rivers & Lakes tournament and catch an ocean species — it should not score,
   while a river species should. (Test a species that *should* pass, not just one that fails; a broken filter
   can look correct if you only check exclusions.)
6. **Lure flow**: catch a Golden Bass in a river → recipe toast; craft the Gilded Spinner; hold it offhand and
   fish the same river → common catches should convert (~1 in 3) with an actionbar "worked!" message and one
   lure consumed. Then verify a condition-breaker: Nightcrawler at noon should still produce Midnight Eels.

## Testing

Headless regression testing runs over RCON with no player needed — see `tools/README.md` for the harness,
the ready-to-run vanilla servers in `tools/vanilla-server/` (1.21.1) and `tools/vanilla-server-26/` (26.2),
and what to check in the output. Run it after any pack change or version port.

What RCON **cannot** cover, and what needs a live player every release: `/trigger` entry points, offhand
lure detection on real casts, emerald buy-in collection, advancement-driven recipe unlocks, and trophy
delivery. Both the 1.1.0 and 1.2.1 release bugs were found this way — budget one live session before
publishing.

## Mod compatibility (verified 2026-07-18)

Loads with **zero errors** on a NeoForge 21.1.172 dedicated dev server with Forgework installed — all
recipes, item modifiers, the guide book, and every function parse clean. PhytoForge's global loot modifier
targets only its own structure tables, and Forgework/Gunsmith only add to vanilla block *tags* (tags merge, so
no conflict). NeoForge GLMs in general apply on top of the final fishing loot table, so mods that inject
fishing loot that way stack with this pack's override; only another pack/mod *replacing*
`minecraft:loot_table/gameplay/fishing/fish.json` outright would conflict.

## Known limitations / roadmap

- Loot override replaces `minecraft:loot_table/gameplay/fishing/fish.json` — other packs overriding the same
  file will conflict (standard datapack caveat).
- The Almanac in a player's inventory is a snapshot taken when it was given; after a pack update, players
  need a fresh copy via `/trigger rr.guide`.
- The book screen's on-screen position is client-hardcoded and cannot be changed by a datapack.
- Roadmap ideas from design: moving hotspot markers with bubble particles (bonus loot for casting near them),
  upgradeable fishing boats + fish-finder GUI (needs a NeoForge companion mod), Modrinth release as a
  datapack-in-jar.
