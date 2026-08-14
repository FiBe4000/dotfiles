# Color schemes

Each file in this directory (e.g. `everforest`, `nord`) is a **source palette**: a
hand-edited `key=value` file that `scripts/generate-colors <scheme>` reads to produce
the format-specific color files consumed by each component.

## Schema

A scheme file is plain `key=value` lines. Blank lines and lines starting with `#` are
ignored (used for comments). Every scheme **must** define all 17 of these keys — no more
are required, and any missing one makes `generate-colors` abort:

```
bg0 bg1 bg2 bg3      # backgrounds, dark → light
fg0 fg1 fg2          # foregrounds, dark → light
accent0 accent1 accent2 accent3   # theme accents
red orange yellow green blue purple   # semantic colors
```

`generate-colors` validates presence only (see `NAMES=(...)` and the "Missing color"
check in the script); it does not check the value format, so keeping the format below is
on you.

## Value format

**Bare 6-digit hex, no leading `#`** (lowercase by convention). Example:

```
bg0=272e33
red=e67e80
```

The generator adds whatever prefix each target needs (`rgb(...)` for Hyprland, `#` for
eww/swaync/rofi/kitty/zsh), so the `#` must **not** be present in the source.

## Generated files — do not hand-edit

Running `generate-colors <scheme>` overwrites these outputs, each carrying a header
`Generated from colors/<scheme> — do not edit manually`:

- `config/hypr/colors.conf` (hyprlang `$var = rgb(...)`; kept for hyprlock, which stays hyprlang)
- `config/hypr/colors.lua` (Lua module returning bare-hex strings; `dofile`d by hyprland.lua)
- `config/eww/_colors.scss` (SCSS `$var`)
- `config/swaync/colors.css` (GTK CSS `@define-color`)
- `config/rofi/colors.rasi` (rasi vars)
- `config/kitty/colors.conf` (kitty color config)
- `zsh/colors.zsh` (shell prompt vars)

Edit the **source scheme file** here and regenerate; never edit the generated files
directly — your changes are lost on the next run.

## Usage

```
scripts/generate-colors everforest   # regenerate all outputs (default scheme: nord)
scripts/apply-theme everforest       # regenerate, then reload running components
```

## Adding a new scheme

1. Copy an existing file (e.g. `cp everforest myscheme`).
2. Set all 17 keys to bare-hex values.
3. Run `scripts/generate-colors myscheme` (or `scripts/apply-theme myscheme`).
