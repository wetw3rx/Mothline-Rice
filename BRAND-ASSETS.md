# Mothline Brand Assets

Canonical brand package established August 30, 2026.

- Version: 1
- Format: sRGB PNG with alpha transparency
- Natural aspect ratio: 3:2
- Canonical source SHA-256:
  `0ed63c0bf724ecaa3be550595d2f5805ee073af4db1d911f725b5416f4d740cc`

## Canonical master

`assets/brand/masters/mothline-lockup-alpha-master-v1.png`

The 1536×1024 master is the authoritative full Mothline lockup: moth,
fine-line circle, vertical red kana, and lower wordmark treatment.

Never resize, recompress, overwrite, or use the master as a working file.
Generate all future full-lockup exports from this master.

## Approved exports

| File | Dimensions | Approved use |
|---|---:|---|
| `mothline-lockup-alpha-1024w-v1.png` | 1024×683 | Start pages, Fastfetch, large panels |
| `mothline-lockup-alpha-768w-v1.png` | 768×512 | Desktop UI and documentation |
| `mothline-lockup-alpha-512w-v1.png` | 512×341 | Standard web/application placement |
| `mothline-lockup-alpha-256w-v1.png` | 256×171 | Smallest approved full lockup |

Use the smallest export that is at least as large as its rendered width.
Never enlarge a smaller export when a larger approved export exists.

## Minimum size

Do not display the full lockup below 256 pixels wide. Below that size, its
kana and fine-line details lose clarity.

Launchers, favicons, tray icons, and compact UI must use the future approved
moth-only micro mark from job #5. Do not crop an icon from the full lockup.

## Clear space and placement

Maintain clear space on every side equal to at least one-sixteenth (6.25%)
of the lockup’s rendered width.

- Preserve the complete 3:2 canvas and natural aspect ratio.
- Center using the complete transparent canvas.
- Keep it isolated from text, borders, controls, and other logos.
- Prefer black, near-black, or restrained Mothline-compatible backgrounds.
- Confirm the kana, pale moth detail, and fine-line circle remain legible.

## Approved usage

- Fastfetch and terminal identity panels
- Mothline start pages and dashboards
- Documentation covers and project records
- SDDM, lockscreen, and desktop identity placements
- Static DivingCrush placement when the Mothline relationship is intentional

## Prohibited modifications

Do not:

- Stretch, squash, rotate, skew, mirror, or crop the lockup
- Rearrange, remove, or recolor its elements
- Add glow, shadow, outline, bevel, or animation to the master
- Place it on a background that obscures its details
- Overwrite the master or approved exports
- Treat deployment copies as canonical masters

A deliberate variant requires a descriptive filename, new version number,
documentation here, and an entry in the checksum manifest.

## Naming standard

Use lowercase, hyphen-separated filenames:

`mothline-<asset>-<variant>-<size>-v<version>.<extension>`

Examples:

- `mothline-lockup-alpha-master-v1.png`
- `mothline-lockup-alpha-512w-v1.png`
- `mothline-moth-alpha-128-v1.png` — reserved for a future approved mark

## Integrity verification

From the repository root:

```zsh
cd assets/brand
sha256sum --check SHA256SUMS
```

Every asset must report `OK`. Never silently replace a recorded file.

## Package structure

```text
assets/brand/
├── SHA256SUMS
├── masters/
│   └── mothline-lockup-alpha-master-v1.png
└── exports/
    ├── mothline-lockup-alpha-1024w-v1.png
    ├── mothline-lockup-alpha-768w-v1.png
    ├── mothline-lockup-alpha-512w-v1.png
    ├── mothline-lockup-alpha-256w-v1.png
    └── icons/
        └── README.md
```

The icons directory remains reserved until job #5 produces and verifies the
standalone moth and micro-size exports.
