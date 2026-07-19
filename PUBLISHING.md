# Reel Rivals — publishing kit (current as of v1.2.1 "Fair Play" hotfix)

Everything for the Modrinth project page. Art lives in `assets/`
(icon.png = project icon, banner.png = featured gallery image, card_*.png = gallery).

**Files to upload — ADD as new versions; do not delete the 1.1.0 or 1.2.0 versions**
(Modrinth automatically serves each player the newest file tagged for their game version):

| Upload as version | File | Game version tag |
|---|---|---|
| `1.2.1+mc1.21.1` | `dist/ReelRivals-1.2.1+mc1.21.1.zip` | 1.21.1 |
| `1.2.1+mc26.2` | `dist/ReelRivals-1.2.1+mc26.2.zip` | 26.2 |

Both are loader "datapack" and carry identical content — same 28 fish, tackle, tournaments,
leaderboard, and Almanac — just built for each version's data format. Both were verified
error-free and smoke-tested on their own dedicated vanilla server. Paste the 1.2.1 changelog
(below) into each upload's changelog field.

**If you already uploaded 1.2.0**: it shipped with a bug (see 1.2.1 changelog) — upload 1.2.1
promptly so new downloaders land on the fix, and consider a pinned comment on the 1.2.0 version
pointing people to update.

---

## Summary (Modrinth's short-description field)

> Competitive fishing for vanilla 1.21.1 — 28 weighed species, craftable lures that target them,
> server records, a live catch leaderboard, and player-hosted tournaments with emerald buy-ins,
> trophies, and glory. No mods. No ops. Just /trigger.

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

## 📈 The long grind

Every cast counts toward something. 100 catches unlock **Abyssal Chum** (Luck IV). A 15 kg
monster earns *Leviathan*. 250 catches plus a Leviathan forge the **Legend Rod** — Luck of
the Sea VIII, unbreakable. 500 catches serve the **King's Feast** (Luck V for 8 minutes —
the bait that makes legends realistic). And at 1,000 catches the server stops to announce a
**Master of the Deep**. Four rod tiers, five bait tiers, and a `/trigger rr.top` **live
leaderboard** of the server's top anglers — visible even while everyone keeps fishing.

## 📖 The Angler's Almanac

Every player gets a free in-game field guide — 27 pages with a clickable, linked table of
contents and a `<< Contents` jump on every page: every species with where and when it bites,
every lure recipe, every rod's build path. `/trigger rr.guide` any time.

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
| `card_progression.png` | Grind for legends: four rod tiers, five bait tiers, and a live Top Anglers leaderboard |
| *(your screenshots)* | Add 2–3 real in-game shots (F2): a weighed catch tooltip, a record broadcast in chat, the tournament bossbar mid-match, the Top Anglers sidebar. Real gameplay screenshots convert better than any promo art — put at least one before the cards. |

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

Categories: `game-mechanics`, `minigame`, `adventure`. License: your choice (MIT if you want
addon authors; All Rights Reserved if not).
