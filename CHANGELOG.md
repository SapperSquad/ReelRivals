# Changelog

## [1.4.1] — Wider Waters

Reach, not features. The same pack now covers six more Minecraft versions, and one real bug is fixed.

- **Supports 1.21.10, 1.21.11, 26.1, 26.1.1, 26.1.2 and 26.2 from one artifact.** The 26.x build now declares `min_format` 88 / `max_format` 107 instead of a single `pack_format`. Verified live on 1.21.10 (format 88), 1.21.11 (94) and 26.1.2 (101); 26.2 (107) is its native target. 26.1 and 26.1.1 are inferred from 26.1.2 rather than individually tested.
- **Fixed a silent bug shipped in 1.4.0's 26.2 build.** Loot tables set model IDs with `{"function":"minecraft:set_custom_model_data","value":N}`, which still parses on 26.x but produces an *empty* component — so all 24 custom species lost their model IDs and no resource pack could re-skin them. The correct modern form is `"floats":{"mode":"replace_all","values":[N]}`, established by experiment. `port_to_26.ps1` now rewrites it. The 1.21.1 build was never affected.
- No gameplay changes.

## [1.4.0] — Bait the Hook

Three ways to keep coming back to the water.

- **The Bounty Board.** There's always an active bounty species. Land it to claim **16 emeralds** (once per rotation), and it sells for **double** at the market until the bounty rotates. The target rerolls every 7 in-game days (tunable) and never repeats twice in a row. Everyone gets a chat announcement when a new bounty opens.
- **The Fish Market.** Cash out your catches for emeralds. `/trigger rr.market` sells the fish in your hand **priced by its exact weight** (a 25 kg King Sturgeon is worth far more than a minnow), and the bounty species pays 2×. `/trigger rr.sellall` sells your whole catch at once at a flat rate — fast, with a small convenience discount. Big catches are worth selling by hand.
- **The Angler's Log.** `/trigger rr.stats` shows your own lifetime numbers: total catches, personal-best weight, tournaments played and won, bounties claimed, emeralds earned at market, and which rods you've earned.
- Every weighed fish now carries its numeric weight as data on the item, not just as lore text — this is what lets the market price by weight (and what a future economy mod could read). Fish caught before 1.4.0 still sell, at the minimum price.
- Tunables for server admins: bounty period (`#bperiod`, default 7 days) and market price (`#emper`, kg per emerald, default 1).

## [1.3.0] — Two Paths

The rod ladder forks. Everyone still earns the Angler's and Master's Rods the same way, but the top end now runs down two separate tracks — and both are fully obtainable.

- **New: Naturalist's Rod** (Lure III, Luck of the Sea VI, unbreakable) — earned by landing a catch in all nine waters: rivers, lakes, open ocean, warm seas, frozen seas, the deeps, swamps, jungles, and the End. This also fixes a real gap: the Champion's Rod needs 2+ players for a tournament, so solo players previously had nothing between the Master's Rod and the Legend Rod.
- **New: Grandmaster's Rod** (Lure IV, Luck of the Sea VII, unbreakable) — the circuit capstone, for 5 tournament wins, or 3 wins across 20 tournaments played.
- **The Legend Rod is no longer a catch-count grind.** It now requires *every species on the ledger* plus a 15 kg leviathan. The old gate was 250 catches, which rewarded AFK farming rather than actually fishing the world. **If you were working toward the old 250-catch unlock, you'll now need to finish the ledger** — anyone who already owns the rod keeps it.
- The two capstones are deliberately different rather than one being strictly better: Luck of the Sea drives rarity, Lure drives bite speed. The Legend Rod hunts legends; the Grandmaster's Rod fishes about twice as fast.
- Almanac expanded to 29 pages with a page for each rod path.

## [1.2.1] — Fair Play Hotfix

Fixes the actionbar and tournament target bugs from 1.2.0.

- Catch feedback was showing the literal text "$(disp)" instead of the fish's name — fixed. Every catch now correctly shows its real species and weight.
- Tournament target categories (Rivers & Lakes / Ocean / Trophy Hunt) were not filtering catches correctly due to the same underlying bug — fixed and re-verified.
- No other changes since 1.2.0.

## [1.2.0] — The Fair Play Update

- Catch feedback: every catch now shows species + weight on your actionbar; during a tournament it also shows your updated score.
- Fixed catch theft: fish and tournament points now go to the player who reeled in, not whoever stands closest to the bobber.
- New tournament rules for hosts: target categories (Rivers & Lakes / Ocean / Trophy Hunt), gear rules (Fair Play: no Luck of the Sea · Pro League: Luck IV+ required), and low-stakes buy-ins (1 / 2 / 4 emeralds) so early-game players can join.
- The record ledger now shows who holds each record.
- Almanac overhaul: two-page table of contents, plain-English lure pages, clearer titles.

## [1.1.0] — Initial Public Release

Initial public release. 28 weighed species with biome/time/weather habitats (including End fishing), learn-by-catching targeted lures, Bait Tins I–V, four rod tiers up to the Legend Rod, a catch-count progression ladder to 1,000, per-species server records, a live Top Anglers leaderboard, player-hosted buy-in tournaments with automatic payouts and trophies, and the 27-page Angler's Almanac.
