# Reel Rivals

Competitive fishing for **vanilla Minecraft 1.21.1** (pack_format 48). Every fish you reel in gets a rolled
weight engraved on it. Rare species spawn by biome, weather, and time of day. Server records are tracked and
announced. Anyone can host a buy-in tournament — no ops required, everything runs off `/trigger`.

## Versions

Two builds, same content, one per Minecraft data-format line. `tools/build.ps1` produces both:

| Build | Minecraft | Source tree | datapack format |
|---|---|---|---|
| `dist/ReelRivals-1.1.0+mc1.21.1.zip` | 1.21.1 | `datapack/` (the source of truth) | 48 |
| `dist/ReelRivals-1.1.0+mc26.2.zip` | 26.2 | `datapack-26x/` (generated) | 107 |

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
3. Optional but recommended for gear gating: `/gamerule doLimitedCrafting true`
   (without it, players who look up the recipes can craft rods before unlocking them).

No resource pack required — custom fish reuse vanilla fish items with colored names. All custom items carry
`custom_model_data` values (fish 790001+, bait 790201+, rods 790301+, trophies 790101+) so a resource pack
can re-skin them later without touching the datapack.

## Player commands

| Command | What it does |
|---|---|
| `/trigger rr.help` | Quick how-to |
| `/trigger rr.host` | Host a tournament — clickable chat menu for scoring mode, duration, buy-in, payout split |
| `/trigger rr.join` | Join an open lobby (pays the emerald buy-in into the pot) |
| `/trigger rr.records` | Server record ledger (best weight per species + in-game day) |
| `/trigger rr.guide` | Get the **Angler's Almanac** — 25-page field guide (fish + conditions, lure recipes, gear build paths, tournament commands). No enchant glint, grouped clickable table of contents, and a [ Contents ] link in every page footer. Also auto-given to each player on first join. Note: books already in inventories are snapshots — grab a fresh copy after updating the pack. |

| `/trigger rr.top` | Toggle the **Top Anglers** sidebar — a live leaderboard of lifetime catches (top ~15, sorted, offline players included). Auto-hides during tournaments (the sidebar shows live standings then). |

Admin: `/function reelrivals:admin/reset` force-cancels a stuck tournament and refunds buy-ins.

## Systems

- **Weighed catches** — every fished item rolls a weight (shown as `X.Y kg` in lore). Weights drive records,
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
- **Gear ladder** — Bait Tins I–III (consumable Luck buffs; Luck feeds the vanilla fishing `quality` system) and
  three rod tiers. Unlocks: first catch → Bait I; 10 catches → Angler's Rod + Bait II; 50 catches *or* a 10 kg
  catch → Master's Rod + Bait III; 5 tournaments played *or* 1 win → Champion's Rod. Bait (Luck) and lures
  (targeting) stack — bait raises rare bites, lures convert the boring ones.
- **The long grind** (late game): 100 catches → Abyssal Chum (Luck IV) · a 15 kg catch → *Leviathan* ·
  250 catches + Leviathan → the **Legend Rod** (Luck of the Sea VIII, unbreakable) · 500 catches →
  **King's Feast** (Luck V, 8 min — makes the quality-4 legends realistically huntable) · 1000 catches →
  *Master of the Deep*: server-wide broadcast and a unique keepsake trophy.
- **Tournaments** — host picks scoring (Total Weight / Biggest Catch / Most Catches), duration (5/10/15 min),
  buy-in (0–64 emeralds), payout (winner-takes-all or 60/30/10). 60-second join window, bossbar countdown,
  sidebar live standings, a 45-second **Feeding Frenzy** (+25% weight) at the halfway mark, ranked results,
  automatic pot payout, and engraved Gold/Silver/Bronze trophies (winner name, in-game day, final score).
  Payouts queue in a ledger and auto-deliver when the recipient is online, so a crash or logout can't eat the pot.
  Trophies are baked with the tournament day and final score; the winner's name is immortalized in the results
  broadcast and the record announcements (item text in 1.21.1 can't bake player names — verified in testing).
- **Advancements** — On the Scale, The Old King, Master Angler (catch all 28), Regular at the Docks,
  Heavyweight, Circuit Regular, Tournament Champion, plus hidden per-species catches that unlock each lure.

## Design notes / anti-cheese

- Biggest Catch is the default mode and AFK-farm resistant; Most Catches is offered but hosts should know AFK
  farms can grind it.
- Buy-ins are emeralds only, by design — fungible escrow makes refunds and splits trustworthy. Wagering items
  is left to house rules.
- Ties break by whoever the ranking pass finds first (effectively arbitrary); dead-even scores are rare with
  weight-based modes.
- If two players reel in the same species within 12 blocks in the same tick, attribution can cross over. Rare;
  harmless outside photo finishes.

## First-load test checklist

1. `/reload` → load message appears, no errors in the log.
2. Fish anything → item lore shows `Weight: X.Y kg`; first catch grants **On the Scale** + Bait I recipe.
3. Beat a record → server-wide record broadcast; `/trigger rr.records` shows it.
4. `/trigger rr.host` → menu clicks respond; open lobby with 2 players (or use a second account); verify
   emeralds are taken, the countdown bossbar runs, and payouts + trophies land at the end.
5. **Lure flow**: catch a Golden Bass in a river → recipe toast; craft the Gilded Spinner; hold it offhand and
   fish the same river → common catches should convert (~1 in 3) with an actionbar "worked!" message and one
   lure consumed. Then verify a condition-breaker: Nightcrawler at noon should still produce Midnight Eels.

## Headless playtest (2026-07-18)

Verified live on the Forgework dev server via RCON (no player): weight rolls bake literal lore that matches the
record ledger exactly; weighed fish cannot be re-weighed; lure conversion re-species common catches, renames
them, and clears the convertible flag; converted fish weigh and set records correctly; the Almanac generates
with all 17 pages; the tournament lobby auto-cancels without entrants; the bossbar counts down with padded
minutes:seconds; feeding frenzy fires at halfway; and the end/payout/cleanup chain leaves clean state.
Still needs a real player to confirm: offhand lure detection on real casts, emerald buy-in collection,
advancement-driven recipe unlocks, and trophy delivery.

## Mod compatibility (verified 2026-07-18)

Loads with **zero errors** on a NeoForge 21.1.172 dedicated dev server with Forgework installed — all 23
recipes, 39 item modifiers, the guide book, and every function parse clean. PhytoForge's global loot modifier
targets only its own structure tables, and Forgework/Gunsmith only add to vanilla block *tags* (tags merge, so
no conflict). NeoForge GLMs in general apply on top of the final fishing loot table, so mods that inject
fishing loot that way stack with this pack's override; only another pack/mod *replacing*
`minecraft:loot_table/gameplay/fishing/fish.json` outright would conflict.

## Known limitations / roadmap

- Loot override replaces `minecraft:loot_table/gameplay/fishing/fish.json` — other packs overriding the same
  file will conflict (standard datapack caveat).
- Roadmap ideas from design: moving hotspot markers with bubble particles (bonus loot for casting near them),
  upgradeable fishing boats + fish-finder GUI (needs a NeoForge companion mod), Modrinth release as a
  datapack-in-jar.
