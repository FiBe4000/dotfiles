# Theme (font) settings

`theme/fonts` is the single hand-edited source for the UI/monospace fonts, the
font-family counterpart of the palette files in `colors/`. `scripts/generate-colors`
reads it and emits format-specific font partials that each component consumes the
same way it consumes the generated color partials.

This directory is deliberately **outside `colors/`** so the scheme scan that
enumerates selectable palettes never picks it up.

## Schema

`theme/fonts` is plain `key=value` lines. Blank lines and lines starting with `#`
are ignored. Values are bare font-family names / sizes — no quotes, no units, no
leading `#`; the generator adds whatever each target needs.

```
mono_font          # optional single override family for kitty+eww+rofi; blank = use fallbacks
kitty_font         # kitty family    (used when mono_font is blank)
eww_font           # eww bar family  (used when mono_font is blank)
rofi_font          # rofi family     (used when mono_font is blank)
kitty_font_size    # kitty size (points)
eww_font_size      # eww size (pixels)
rofi_font_size     # rofi size (points)
```

`generate-colors` requires the three per-target fallback families and the three
sizes to be present — six keys in all (`mono_font` may be blank or omitted); a
missing required key aborts.

### The `mono_font` knob

The three monospace targets (kitty, eww, rofi) historically use different
families. Setting `mono_font` applies one family to all three at once — this is
the single "font" setting a future settings toggle drives. Left blank (the
default), each target keeps its own `*_font` value so the pipeline is a no-op
against the historical fonts.

## Generated files — do not hand-edit

Running `generate-colors <scheme>` also overwrites these font partials, each
carrying a `Generated from theme/fonts — do not edit manually` header:

- `config/kitty/fonts.conf`   (kitty `font_family` / `font_size`, `include`d)
- `config/eww/_fonts.scss`    (SCSS `$mono-font` / `$mono-font-size`, `@import`ed)
- `config/rofi/fonts.rasi`    (rasi `configuration { font: ... }`, `@import`ed)

Edit `theme/fonts` and regenerate; never edit the generated files directly.

> Not yet templated: `config/hypr/hyprlock.conf` uses a separate sans family
> (`Noto Sans`) with per-label sizes. Wiring it through a `source`d hyprlang
> partial is a clean follow-up but was deferred to avoid any lock-screen risk.
