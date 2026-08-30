# Reel Rivals — publishing kit (current as of v1.4.1 "Wider Waters")

Everything for the Modrinth project page. Art lives in `assets/`
(icon.png = project icon, banner.png = featured gallery image, card_*.png = gallery).

**Files to upload — ADD as new versions; do not delete older versions**
(Modrinth automatically serves each player the newest file tagged for their game version):

| Upload as version | File | Game version tags | Loader |
|---|---|---|---|
| `1.4.1+mc1.21.1` | `dist/ReelRivals-1.4.1+mc1.21.1.zip` | 1.21.1 | **datapack** |
| `1.4.1+mc1.21.10-26.2` | `dist/ReelRivals-1.4.1+mc1.21.10-26.2.zip` | 1.21.10, 1.21.11, 26.1, 26.1.1, 26.1.2, 26.2 | **datapack** |
| `1.4.1+mc1.21.1-neoforge` | `dist/ReelRivals-1.4.1+mc1.21.1-neoforge.jar` | 1.21.1 | **neoforge** |

**The second zip is ONE file covering six game versions** — its `pack.mcmeta` declares
`min_format 88 / max_format 107` rather than a single format. Do not split it per version.

All carry identical content — same 28 fish, tackle, tournaments, leaderboard, and Almanac. The
`.zip`s are built for each version's data format; the `.jar` is the 1.21.1 datapack wrapped as a
code-free NeoForge mod (same content, installs like a mod, always loads after vanilla so the
fishing-loot override can't lose the pack-order race). Paste the 1.4.1 changelog (below) into each
upload's changelog field.

**Set the loader per file.** On the SAME Modrinth version you can attach both the zip (loader
`datapack`) and the jar (loader `neoforge`) so a NeoForge player's mod-list filter finds it — or
upload them as separate versions. The **zip is loader-agnostic**: it runs on vanilla, Fabric,
Quilt, NeoForge, and Paper alike. Say so on the project page — a Fabric player scanning listings
will not assume a "datapack" works for them.

**The NeoForge `.jar` is live-verified** (2026-08-09, NeoForge 1.21.1 dev server alongside two other
mods): it appears in the mod list, its load function runs, the weigh pipeline works, and rolling the
vanilla fishing loot table yields Reel Rivals data — proving the jar wins the loot override that the
zip's install steps have to warn players about. `publish.ps1` uploads it automatically; use
`-JarOnly` to add it to a release whose zips are already up.

**Heads-up for the 1.4.0 release notes**: nothing is taken away this release, but two things are
worth stating plainly so they don't read as bugs.
1. The bounty rotates on **in-game days** (7 by default), not real-world weeks — vanilla has no
   wall-clock query. On a 24/7 server that is faster than a week; admins raise `#bperiod` to slow it.
2. Fish caught **before** 1.4.0 have no weight data baked in, so they sell at the 1-emerald minimum
   rather than by weight. Newly caught fish price correctly. Not a bug, and not worth a migration.

Still true from 1.3.0: the Legend Rod's unlock is "every species + a 15 kg catch," not 250 catches.

---

## Summary (Modrinth's short-description field)

> Competitive fishing for vanilla Minecraft — 28 weighed species, craftable lures that target them,
> server records, a live catch leaderboard, and player-hosted tournaments with emerald buy-ins,
> trophies, and glory. No mods. No ops. Just /trigger.

**Store copy is CURRENT as of 1.4.1** — description updated and changelog posted on both platforms
2026-08-09.

**Do not pin the short description to one Minecraft version.** It said "for vanilla 1.21.1" through
1.4.0, which undersold the pack the moment it covered eight versions. Supported versions belong in
the version tags, not the tagline.

---

## Project description (paste into the body)

# 🎣 Every catch has a weight. And your rivals are watching.

**Reel Rivals** turns vanilla fishing into a competition. Every fish you reel in is weighed
to the decimal — flashed on your screen, inked onto the catch — and the moment you beat a
species record, **the whole server hears about it**, with your name on the ledger to prove
it. From there, it escalates.

## 🐟 28 species across every water in the game

Rivers hide Golden Bass by day and Mudskip Gar by night. Quiet ponds hold Mirror Carp and
the moonlit Koi. Oceans run on schedules — Sunfin Tuna under the sun, Storm Marlin in the
rain, and the **Thunderfin**, which surfaces only while thunder splits the sky. Warm reefs,
frozen seas, swamps, jungles, the deep dark — every biome fishes differently. Three legends
crown the ledger: the **King Sturgeon** (up to 25 kg, anywhere, almost never), the **Ancient
Coelacanth** haunting the deep oceans — and the **Void Skate**, which bites only in the End,
where there is no water unless you bring your own.

## 🪝 Learn the fish. Craft the lure.

Catch a species once and you *learn* it — unlocking a craftable lure that targets it.
Hold the lure in your offhand and about 1 in 3 common bites become the fish you're hunting,
in its home water. Special lures cheat nature itself: the **Nightcrawler** catches Midnight
Eels at noon, the **Storm Jig** lands Marlins under clear skies, and the **King's Roe** —
heart of the sea, golden apple — tempts the King himself, 1 time in 10. Stack Bait Tins
(Luck I–V) on top and go all in.

## 🏆 Tournaments with real stakes

Any player can host — no ops, no plugins, one command:

- **Pick the rules**: Total Weight, Biggest Catch, or Most Catches · 5/10/15 minutes
- **Pick the fish**: any species — or Rivers & Lakes only, Ocean only, or a **Trophy Hunt**
  where only rare and legendary species score
- **Pick the gear**: open class, **Fair Play** (no Luck of the Sea — everyone on even rods),
  or **Pro League** (Luck of the Sea IV+ required)
- **Set the stakes**: buy-ins from 1 emerald to 64, winner-takes-all or 60/30/10
- **Fish the frenzy**: bossbar countdown, live standings, per-catch score updates on your
  actionbar, and a +25% Feeding Frenzy at halfway
- **Take the pot**: automatic crash-proof payouts, trophies for the podium stamped with the
  tournament day and final score, and your name broadcast to everyone who lost

## 📈 Two paths to the top

Every angler earns the same first two rods. Then the ladder forks — and you can walk both.

Fish **every water in the world** — river, lake, open ocean, warm reef, frozen sea, the deeps,
swamp, jungle, and the End — and the **Naturalist's Rod** is yours. Finish the entire ledger,
all 28 species, with a 15 kg leviathan on your record, and you forge the **Legend Rod**: Luck
of the Sea VIII, unbreakable, the finest rare-hunting rod in the game.

Or win. Five tournament victories crown you **Grandmaster**, and the Grandmaster's Rod fishes
roughly twice as fast as anything else on the water — the rod you want when the clock is
running and volume decides it.

Neither is strictly better. Luck of the Sea pulls rarity; Lure pulls speed. Around them: five
bait tiers up to **King's Feast** (Luck V), **Abyssal Chum** at 100 catches, *Master of the
Deep* at 1,000, and a `/trigger rr.top` **live leaderboard** of the server's best.

## 🎯 There's always a bounty

One species is wanted at any given time. Land it and you claim **16 emeralds** on the spot — and
until the bounty rotates, that fish sells for **double**. The target rerolls on a timer, never
repeats twice running, and the whole server hears about it the moment a new one opens.

## 💰 Sell the catch

Fish are worth money now, and **weight is the price**. Hold a catch and `/trigger rr.market` pays
you by the kilo — a 25 kg King Sturgeon is a payday, a minnow is pocket change. In a hurry?
`/trigger rr.sellall` clears your whole haul at a flat rate: faster, slightly cheaper, so the
monsters are still worth selling by hand. Then take the emeralds straight to a tournament buy-in.

Your trophies are safe — they can't be sold by accident.

## 📊 Your own log

`/trigger rr.stats` is just yours: lifetime catches, your personal best to the decimal, tournaments
played and won, bounties claimed, emeralds earned, and every rod you've unlocked. The leaderboard
says who's winning. The log says how far *you've* come.

## 📖 The Angler's Almanac

Every player gets a free in-game field guide — 30 pages with a clickable, linked table of
contents and a `<< Contents` jump on every page: every species with where and when it bites,
every lure recipe, and both rod build paths. `/trigger rr.guide` any time.

And your catch is never wasted: every fish is still real vanilla food. Cook it and it becomes
an ordinary meal — or frame it, and the name and weight stay forever. **Eat it or mount it.**

## ⚙️ Zero-friction install

Drop the release **zip as-is** (don't extract it) into `world/datapacks`, done. **100%
vanilla** — works on vanilla servers and modded servers alike (verified on both a pure
vanilla dedicated server and NeoForge). Everything runs on `/trigger`, so players never
need permissions. If fishing ever gives plain, weightless fish, another pack is overriding
the fishing loot — the pack detects this and prints the one-command fix in chat.

| Command | |
|---|---|
| `/trigger rr.help` | how to play |
| `/trigger rr.host` | host a tournament |
| `/trigger rr.join` | enter the lobby |
| `/trigger rr.records` | per-species record ledger |
| `/trigger rr.top` | live Top Anglers leaderboard |
| `/trigger rr.stats` | your own Angler's Log |
| `/trigger rr.market` | sell the fish in your hand, by weight |
| `/trigger rr.sellall` | sell your whole catch at a flat rate |
| `/trigger rr.guide` | the Almanac |

*Tip: `/gamerule doLimitedCrafting true` makes gear unlocks binding.*

---

## Gallery upload plan

| File | Caption |
|---|---|
| `banner.png` (featured) | Wager. Weigh-in. Win. |
| `card_species.png` | 28 species across rivers, lakes, oceans, swamps, jungles, the deeps — and the End |
| `card_lures.png` | Learn a fish by catching it — then craft the lure that hunts it |
| `card_tournaments.png` | Player-hosted tournaments: emerald buy-ins, live standings, podium trophies |
| `card_progression.png` | Two paths to the top: six rods across two tracks, five bait tiers, and a live Top Anglers leaderboard |
| `card_market.png` **(new in 1.4.0)** | Every catch pays: a rotating bounty, a market that buys by weight, and a log of everything you've earned |
| *(your screenshots)* | Add 2–3 real in-game shots (F2): a weighed catch tooltip, a record broadcast in chat, the tournament bossbar mid-match, the Top Anglers sidebar. Real gameplay screenshots convert better than any promo art — put at least one before the cards. |

Larger 1280x720 versions for the CurseForge gallery live in `promo/` — `gallery-6-bounty.png` is the
1.4.0 addition, a three-panel breakdown of the bounty, market, and log with the commands along the
bottom. **Both are generated by `tools/GenCards.java`** — edit that, not the PNGs.

**Gallery art is current as of 1.4.0** (uploaded 2026-08-09). The six generated images —
`banner-1920x640`, `gallery-4-gear`, `gallery-5-endgame`, `gallery-6-bounty`, `card_progression`,
`card_market` — are live on both stores. The remaining seven are the original hand-made 1.1.0
exports and are still accurate.

**Next release, re-check these before uploading:** the banner's species count and MC version line,
the gear card's rod roster and unlock text, and the endgame card's milestone list. Those four have
each carried a stale claim at some point — the banner shipped "24 rare species" against a 28-species
pack, and the gear card advertised a 250-catch Legend Rod after that gate had changed. Regenerate
with `java tools/GenCards.java` and compare rather than assuming.

## Changelog for the 1.4.1 uploads

> **1.4.1 — Wider Waters.** Same game, many more versions — plus a real fix.
> - **Now supports Minecraft 1.21.10, 1.21.11, 26.1, 26.1.1, 26.1.2 and 26.2** from a single file,
>   alongside the existing 1.21.1 build.
> - **Fixed: custom fish lost their model IDs on 26.x.** All 24 named species were writing an empty
>   `custom_model_data`, so a resource pack could not re-skin them. Gameplay was unaffected — fish,
>   weights, records and tournaments all worked — but the re-skinning hook the description promises
>   was broken. Verified fixed on 1.21.10, 1.21.11 and 26.1.2.
> - No gameplay changes.

## Changelog for the 1.4.0 uploads

> **1.4.0 — Bait the Hook.** Three ways to keep coming back to the water.
> - **The Bounty Board.** There's always an active bounty species. Land it to claim **16 emeralds**
>   (once per rotation), and it sells for **double** at the market until the bounty rotates. The
>   target rerolls every 7 in-game days (tunable) and never repeats twice in a row.
> - **The Fish Market.** Cash out for emeralds. `/trigger rr.market` sells the fish in your hand
>   **priced by its exact weight** — a 25 kg King Sturgeon is worth far more than a minnow — and the
>   bounty species pays 2×. `/trigger rr.sellall` sells your whole catch at once at a flat rate:
>   fast, with a small convenience discount, so trophies are worth selling by hand.
> - **The Angler's Log.** `/trigger rr.stats` shows your lifetime catches, personal-best weight,
>   tournaments played and won, bounties claimed, emeralds earned, and the rods you've earned.
> - Every weighed fish now carries its numeric weight as item data, not just lore text — that's what
>   lets the market price by weight. Fish caught before 1.4.0 still sell, at the minimum price.
> - Server admins can tune the bounty period (`#bperiod`, default 7 in-game days) and the market
>   rate (`#emper`, kg per emerald, default 1).

## Changelog for the 1.3.0 uploads

> **1.3.0 — Two Paths.** The rod ladder forks at the top, and both tracks are fully obtainable.
> - **New: Naturalist's Rod** (Lure III, Luck of the Sea VI, unbreakable) — earned by landing a
>   catch in all nine waters: rivers, lakes, open ocean, warm seas, frozen seas, the deeps,
>   swamps, jungles, and the End. This also closes a gap for solo players, who previously had
>   nothing between the Master's Rod and the Legend Rod because the Champion's Rod requires a
>   tournament (2+ players).
> - **New: Grandmaster's Rod** (Lure IV, Luck of the Sea VII, unbreakable) — the tournament
>   capstone, for 5 wins, or 3 wins across 20 tournaments played.
> - **The Legend Rod is no longer a catch-count grind.** It now requires every species on the
>   ledger plus a 15 kg leviathan, instead of 250 catches. If you were working toward the old
>   unlock you'll need to finish the ledger; anyone who already has the rod keeps it.
> - The two capstones spend the same power budget differently — Luck of the Sea drives rarity,
>   Lure drives bite speed. The Legend Rod hunts legends; the Grandmaster's Rod fishes about
>   twice as fast.
> - Angler's Almanac expanded to 29 pages, with a page for each rod path.

## Changelog for the 1.2.1 uploads (hotfix)

> **1.2.1 — Fixes the actionbar and tournament target bugs from 1.2.0.**
> - Catch feedback was showing the literal text "$(disp)" instead of the fish's name —
>   fixed. Every catch now correctly shows its real species and weight.
> - Tournament target categories (Rivers & Lakes / Ocean / Trophy Hunt) were not filtering
>   catches correctly due to the same underlying bug — fixed and re-verified.
> - No other changes since 1.2.0.

## Changelog for the 1.2.0 uploads

> **1.2.0 — The Fair Play update.**
> - Catch feedback: every catch now shows species + weight on your actionbar; during a
>   tournament it also shows your updated score.
> - Fixed catch theft: fish and tournament points now go to the player who reeled in,
>   not whoever stands closest to the bobber.
> - New tournament rules for hosts: target categories (Rivers & Lakes / Ocean / Trophy
>   Hunt), gear rules (Fair Play: no Luck of the Sea · Pro League: Luck IV+ required),
>   and low-stakes buy-ins (1 / 2 / 4 emeralds) so early-game players can join.
> - The record ledger now shows who holds each record.
> - Almanac overhaul: two-page table of contents, plain-English lure pages, clearer titles.

## First-version changelog (used for the 1.1.0 uploads)

> Initial public release. 28 weighed species with biome/time/weather habitats (including
> End fishing), learn-by-catching targeted lures, Bait Tins I–V, four rod tiers up to the
> Legend Rod, a catch-count progression ladder to 1,000, per-species server records,
> a live Top Anglers leaderboard, player-hosted buy-in tournaments with automatic payouts
> and trophies, and the 27-page Angler's Almanac.

Categories: `game-mechanics`, `minigame`, `adventure`. License: split policy (SapperSquad,
2026-07-28) — set **All Rights Reserved** on the live Modrinth project's settings page;
the GitHub repo carries an MIT LICENSE.
