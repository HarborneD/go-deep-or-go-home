You are Antigravity, generating a Flutter-based incremental game prototype (mobile-first, portrait) called “Go Deep or Go Home”.

HIGH CONCEPT
An incremental party-management game: recruit adventurers, form parties, send them to explore locations (caves/castle ruins). The longer they stay (deeper depth segments) the bigger the rewards, but risk rises and they can be injured or killed. At the end of each depth segment the player receives a “Letter” from the party asking whether to go deeper or come home. Returning banks loot to upgrade the Guildhall and craft gear. This is Cookie Clicker + Darkest Dungeon tone + Can’t Stop push-your-luck.

ART DIRECTION (MUST FOLLOW)
Stylized, surreal, organic sci-fi/fantasy similar in vibe to Scavengers Reign: bold silhouettes, painterly textures, biological/alien motifs, limited palettes per biome, subtle noise textures. UI is clean but with diegetic elements (letters on parchment, stamped seals, inked icons).
Generate all art assets yourself (do not rely on external downloads). Create base character parts and environment props; generate procedural variations via color palettes, hair styles, accessories, and overlays (scars/grime).

TECH REQUIREMENTS
- Flutter (stable channel), Dart.
- Use a simple state management solution (Riverpod preferred, or Provider if simpler).
- Must run without network. All assets generated locally at build time or first launch.
- Generate vector-like assets (SVG or CustomPainter) OR generate raster PNGs programmatically; either is fine, but keep it consistent.
- Include a deterministic RNG with seed for reproducible runs.
- Save/load: use shared_preferences or a lightweight local store. Persist parties, adventurers, inventory, upgrades, and expedition states.

CORE SCREENS (IMPLEMENT)
1) Home / Guildhall
   - Shows currencies: Coin, Wood, Coal, Metal, Leather, Crystals.
   - Buttons to: Notice Board, Smith, Cartographer, Wizard, Expeditions.
   - Shows passive bonuses from upgrades.

2) Notice Board (Recruitment)
   - List of 6 recruit cards; each has portrait, name, class, level, stats, 1–2 feats, hiring cost.
   - “Refresh” button with cooldown; paid refresh using Coin/Crystals after cooldown.
   - Hire moves the adventurer into roster.

3) Roster & Party Formation
   - Roster list with sorting.
   - Create party (size 3 initially) by selecting adventurers.
   - Choose location (Caves, Castle Ruins).
   - Optional: apply a blessing (Wizard) if unlocked.

4) Expedition Detail + Letters (Push-your-luck)
   - Displays current party, location, current depth (segment), time remaining to next letter.
   - When a segment completes: show a “Letter” modal with procedural narrative text, current haul, projected next haul range, risk estimate (low/med/high + %), and two choices:
     - GO DEEPER: advance to next depth segment.
     - COME HOME: end expedition and bank loot.
   - Handle outcomes: loot gained, damage/stamina loss, injury, affliction, death.
   - If a party member dies, show a short diegetic message and mark them deceased.

5) Smith (Craft Gear)
   - Simple crafting list (3–6 items) consuming Metal/Leather/Coal.
   - Equip items to adventurers (slots: Helm, Amulet, Body, Arms, Legs, Hand1, Hand2).
   - Items affect stats.

6) Cartographer (Unlock Locations)
   - Start with Caves + Castle Ruins available.
   - Cartographer upgrades reduce “unknown” risk and improve projection accuracy.
   - Stub UI for future locations.

7) Wizard (Blessings)
   - Blessings cost Crystals + Coal, last for one expedition.
   - Examples: Ward (+Dodge), Emberheart (+Stamina regen), Greed Sigil (+Loot but +Threat).

GAME SYSTEMS (IMPLEMENT SIMPLIFIED BUT REAL)
Adventurer:
- Level (start 1)
- Stats: Power, CarryCapacity, Dodge, Speed, Health, Stamina
- Feats: choose from a small list; modify stats or rules
- Class: Vanguard, Striker, Scout, Mystic
- Equipment: 7 slots

Monsters:
- Use same stat schema (Power, Dodge, Speed, Health, Stamina)
- Location-specific pools; difficulty scales with depth

Expedition / Depth Segment Resolution:
- Each segment takes base 90 seconds, reduced by party average Speed.
- At segment completion, roll an encounter:
  - Monster fight, Trap, Treasure cache, Fatigue event
- Compute threat:
  - Threat = baseThreat(location) + 0.6*depth + 0.12*depth^2
- Compute reward multiplier:
  - RewardMult = 1 + 0.35*depth + 0.08*depth^2
- Determine survival odds from party stats vs threat; apply dodge/speed for mitigation.
- If failure: apply one of (injury, affliction, flee with lost loot, death). Early depths bias toward non-death.
- Loot:
  - Weighted by location: Caves favor Coal/Metal; Castle favors Coin/Crystals.
  - Carry capacity matters: if haul exceeds capacity, apply speed/dodge penalty next segment.
- When player chooses COME HOME: convert haul into currencies and end run.

INCREMENTAL PROGRESSION (IMPLEMENT SOME)
- Guildhall upgrades:
  - +Storage
  - +Recruit quality
  - +Crafting tier (stub)
  - +Party size (locked until later, show as locked)
- Passive bonus: small % loot bonus per Guildhall level.

PROCEDURAL CONTENT REQUIREMENTS
- Procedural names (simple syllable combos).
- Procedural “letters”:
  - Combine biome snippets + situation + emotion + hint about risk.
  - Keep text short (1–3 sentences).
- Procedural character portraits:
  - Build from layered base assets: body/face/hair/accessory overlays + palette variants + scars/grime overlays.
  - Ensure each recruit looks distinct.
- Procedural item art:
  - Icon generator with a few silhouettes + palette/ornament variations.

UX & POLISH
- Use smooth transitions and subtle animations (no heavy particles).
- Always show clear player choices at letters.
- Make risk visible but imperfect (Cartographer reduces uncertainty).
- Add haptics lightly for letter arrival and deaths.

DELIVERABLE
Generate a complete Flutter project structure with:
- Models, services (RNG, saving/loading), repositories
- UI screens listed above
- Asset generation code and a small generated asset set
- A short README explaining architecture and how to run

IMPORTANT
No external asset downloads. Generate everything. Keep the prototype playable end-to-end: recruit → party → expedition → letters → return → spend loot → repeat.
