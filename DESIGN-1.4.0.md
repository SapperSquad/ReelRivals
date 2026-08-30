# Reel Rivals 1.4.0 — design spec

Three features: the **Bounty Board** (rotating target species), the **Fish Market** (sell catches
for emeralds by weight), and the **Angler's Log** (personal stats). All pure vanilla datapack —
no mod dependency. Locked decisions and mechanics below; the reasoning is here so it isn't
relitigated later.

## Locked decisions

1. **Currency is emeralds, not a mod currency.** Vanilla-first policy (project canon): the datapack
   is a complete game forever; a companion mod is extras only, one-way. Reel Rivals already uses
   emeralds for tournament buy-ins, so the market reuses that. A Coinkeep/other-mod payout is a
   *future optional bridge* gated behind a detection flag — NOT built in 1.4.0, only left room for.

2. **The bounty period is measured in in-game days, default 7.** Vanilla has no wall-clock query, so
   real-world "weekly" is impossible in a datapack. 7 in-game days ≈ 2.3 hours of loaded time. On a
   24/7 server that rotates faster than a real week; the period is a single tunable constant
   (`#bperiod rr.t`) so an admin can raise it. We market it as "rotating bounties," not "weekly," to
   stay honest.

3. **The market prices by weight, and weight now lives on the item.** `apply_weight` bakes the numeric
   weight (`w`, in 0.1-kg units, 1–250) into the fish's `custom_data.reelrivals.w`, alongside the
   existing lore text. This is what lets the market read a fish's weight, and it is exactly the hook a
   future economy mod would need too. Fish caught before 1.4.0 have no `w` and fall back to a flat
   price.

3b. **Weight stays on the fish (not stripped).** Confirmed earlier: nothing reads weight off the item
   for gameplay; it is display + now market value. Keeping it means big catches are worth more money,
   which is the point.

4. **Two sell commands, both provably correct in vanilla — no fragile inventory iteration.**
   - `rr.market` sells the fish in your **main hand** by its exact weight (`data get SelectedItem`,
     unambiguous). Bounty species pays 2×. Precise, best value.
   - `rr.sellall` sells **every weighed fish** at a flat per-fish rate, using `clear @s <pred> 0` to
     count then `clear` to remove. Fast, provably correct, slightly worse value than hand-selling
     trophies — a deliberate convenience discount. No recursion, no read/clear pairing risk.

## Economy balance

Pricing: `emeralds = max(1, floor(kg))` per fish → a 5.4 kg fish = 5 em, a 0.3 kg fish = 1 em, a
25 kg King Sturgeon = 25 em. `rr.sellall` flat rate = 2 em/fish.

Is this a runaway faucet? Fishing is bite-gated (seconds per catch), a typical 2–5 kg fish pays
2–5 em, and tournament buy-ins are 1–64 em. So a session funds a few buy-ins — a healthy
**fish → sell → afford tournaments** loop, not an emerald printer. Legendary fish paying 20–25 em is
a satisfying payoff, not degenerate. On multiplayer this is a mild emerald faucet; that is the
server admin's concern, opt-in (players choose to sell), and the rate is one tunable constant
(`#emper rr.t`, kg per emerald = 1). The bounty's 2× premium is the retention lever: "this week X is
worth double."

## Exploit analysis

- **Trophies are safe.** Master-of-the-Deep and tournament trophies carry `trophy:...`, not
  `weighed:1b`; the Almanac carries `guide:1b`. None match the market's weighed-fish predicate.
- **No double-sell.** Selling removes the item in the same command that pays.
- **Bounty lump reward is once per period per player**, guarded by a `rr_bounty_claimed` tag cleared
  on rotation — not farmable. The per-catch bounty callout and the 2× market premium ARE repeatable,
  but both still require catching + (for the premium) selling, so they are self-limiting.
- **Re-weigh protection unchanged** — `w` is written in the same merge that sets `weighed:1b`, and the
  existing `unweighed:1b` gate still stops a fish being processed twice.

## New scoreboard objectives / storage

| Name | Kind | Meaning |
|---|---|---|
| `rr.market` | trigger | sell held fish |
| `rr.sellall` | trigger | sell all weighed fish flat |
| `rr.stats` | trigger | open the Angler's Log |
| `rr.pb` | dummy (player) | personal-best weight, 0.1-kg units |
| `rr.bounties` | dummy (player) | lifetime bounty lump claims |
| `rr.sold` | dummy (player) | lifetime emeralds earned at market |
| `#bstart rr.t` | global | in-game day the current bounty started |
| `#bperiod rr.t` | global | bounty period in days (default 7, tunable) |
| `#emper rr.t` | global | kg per emerald (default 1, tunable) |
| `reelrivals:bounty` | storage | `{species, disp, color, active}` current target |

## Feature 1 — Bounty Board

- `bounty/rotate` (called throttled from tick, and once from load if never set): reads `time query
  day`; if `day - #bstart >= #bperiod`, roll `random value 1..28`, map index→species via 28 guarded
  lines, avoid immediate repeat, write `reelrivals:bounty`, clear all `rr_bounty_claimed` tags, set
  `#bstart = day`, broadcast "New bounty: <fish> — 2× at market this rotation."
- `bounty/hit` (from `catch/score` when caught species == bounty species): actionbar "★ Bounty fish! ★";
  if player lacks `rr_bounty_claimed`, give a lump reward (16 em), tag them, `rr.bounties += 1`,
  personal chat.
- Catch hook: one `$execute if data storage reelrivals:bounty {species:"$(species)"}` line in
  `catch/score`.

## Feature 2 — Fish Market

- `market/sell_held`: read `SelectedItem` count + `w`; if it isn't a weighed fish, tell the player and
  stop. `em = max(1, w*/ (10*#emper))`; if held species == bounty, `em *= 2`; `clear` the held slot,
  `give` emeralds, `rr.sold += em`, feedback. Missing `w` (old fish) → flat 2 em.
- `market/sell_all`: `clear @s <weighed pred> 0` → count into `#n`; `em = #n * 2`; `clear` them; pay;
  `rr.sold += em`; feedback with the count.
- Bounty-species compare uses a macro (read held species into storage, substitute into an
  `if data storage reelrivals:bounty {species:"$(s)"}` check).

## Feature 3 — Angler's Log

`stats/show` (from `rr.stats`), all `@s`:
- Lifetime catches (`rr.caught`), personal best (`rr.pb` → kg.fr), tournaments played/won
  (`rr.played`/`rr.wins`), gear earned (which rod tags present), bounties claimed (`rr.bounties`),
  emeralds earned at market (`rr.sold`).
- `rr.pb` updated in `catch/score`: `if #last > rr.pb → set`.

## Almanac / docs

Add a "Bounty & Market" page and a stats line to the guide; document `rr.market`, `rr.sellall`,
`rr.stats` in README/PUBLISHING. Bump all docs to 1.4.0 together.
