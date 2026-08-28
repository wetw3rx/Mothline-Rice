# Mothline Start Page Operations

**System:** Daedalus
**Canonical repository:** `~/Projects/mothline-rice`
**Canonical page:** `~/Projects/mothline-rice/startpage/start.html`
**Installed page:** `~/.local/share/startpage/start.html`
**Firefox URL:** `file:///home/skilgore/.local/share/startpage/start.html`

## Approved visual design

The start page uses the Mothline red, teal, black, and bright-bone palette. It preserves the military clock, date, Fishers weather, Google search, responsive layout, and Open-Meteo refresh behavior.

The existing transparent `startpage/moth.png` receives a nondestructive CSS treatment: grayscale, light sepia, increased brightness, restrained contrast, warm bone glow, and a five-second breathing animation. Reduced-motion mode disables animation.

## Approved card order

```text
PERSONAL          WORK             ABODE ~ ABIDE
US NAVY VETERAN   DEVELOPMENT      HACKING
        HOMELAB          STATE OF PLAY
```

The desktop grid uses six underlying tracks. Cards in the first two rows span two tracks each. HOMELAB occupies tracks two and three; STATE OF PLAY occupies tracks four and five. Narrow screens return to two-column and one-column layouts.

## Mothline kana mark

```text
モ
ス
ラ
イ
ン
```

The approved katakana mark uses five explicit stacked `<span>` elements. It does not rely on browser vertical writing mode. The stack is anchored outside the moth container by its right edge, cannot overlap the graphic, pulses with the moth's five-second rhythm, and remains bounded on smaller screens.

## Installation

```bash
cp -a ~/Projects/mothline-rice/startpage/start.html \
  ~/.local/share/startpage/start.html
```

Open directly:

```bash
firefox --new-window \
  file:///home/skilgore/.local/share/startpage/start.html
```

Use `Ctrl+Shift+R` after installation to bypass cached styling.

## Verification

- Canonical and installed files match with `cmp`.
- HTML parses successfully.
- Eight cards appear in the approved order.
- Kana contains exactly モ, ス, ラ, イ, ン.
- Kana remains stacked and completely outside the moth.
- Bone treatment is present.
- No redirect code exists.
- Clock, date, weather, search, and links work.
- Desktop and narrow layouts remain usable.
- Reduced-motion behavior works.
- Firefox displays the local page persistently.

Quick comparison:

```bash
cmp -s ~/Projects/mothline-rice/startpage/start.html \
  ~/.local/share/startpage/start.html \
  && echo PASS || echo FAIL
```

## Backups and recovery

Timestamped backups are stored under:

```text
~/.local/state/mothline-backups/startpage-*
```

Restore the selected approved backup over both canonical and live locations, then verify them with `cmp` and open the page directly in Firefox.

## Change discipline

1. Confirm repository state.
2. Confirm live and canonical pages match.
3. Back up both files.
4. Modify the canonical page.
5. Validate structure and behavior.
6. Copy canonical to live.
7. Refresh Firefox.
8. Obtain visual approval.
9. Document the change.
10. Commit and push only the approved state.

---

**[ VERIFY THE SIGNAL // PRESERVE THE SOURCE ]**
