# Settings4000 — Dotfiles Prep Tasks

Changes to `~/.dotfiles` that make the settings app (see `Settings4000/docs/architecture.md`) simpler and safer to build. Derived mainly from `dotfiles_analysis.md` §5 (with items from §2 and §4); tracked here as the prerequisites/companions that `Settings4000/docs/requirements.md` §9 defers to this file — not app features.

Complexity: 1 = simple/repetitive … 5 = highly complex.

## A. Apply & reload plumbing (required)

- [x] **A1. Add `scripts/apply-theme` wrapper** — Complexity: 2
  Script that runs `generate-colors <scheme>` then reloads each *running* component: `hyprctl reload`, `eww reload`, `swaync-client -rs`, `kill -SIGUSR1 $(pidof kitty)`. Skips absent/stopped components silently; exits non-zero only on generation failure. This is for manual/CLI palette switching and documents the canonical reload set; the app does **not** shell out to it — it runs `generate-colors` and issues the same reloads itself (architecture §6, tasks.md 4.4–4.5), so keep this list and the app's reload table in sync.
  *Accept:* running it after editing `colors/<scheme>` restyles Hyprland, eww, swaync, and kitty without restarts; safe to run when e.g. eww isn't running.

- [x] **A2. Enable kitty remote control** — Complexity: 1
  Add `allow_remote_control socket-only` + `listen_on unix:@kitty-{kitty_pid}` to `kitty.conf` (the `{kitty_pid}` placeholder gives each instance its own socket) so colors can later be applied flicker-free via `kitten @ set-colors` instead of SIGUSR1. Forward-looking: v1 (and A1) keep using SIGUSR1; the socket only enables the switch later.
  *Accept:* `kitten @ --to unix:@kitty-$PID ls` works against a running kitty; SIGUSR1 path still works as fallback.

## B. Consolidate duplicated values (required — writer desync hazards)

- [ ] **B1. Single cursor source of truth** — Complexity: 2
  Resolve the conflict: `hyprland.conf` sets `XCURSOR_THEME=breeze_cursors`/24, `config/uwsm/env` sets `Nordic-cursors`/16. Pick one intended value, set it identically in both places (uwsm/env as canonical for the session env, hyprland.conf env matching), and comment each with a pointer to the other.
  *Accept:* both files declare the same theme+size; cursor renders consistently in Hyprland and XWayland apps after relogin.

- [ ] **B2. Unify wallpaper & lock-screen background** — Complexity: 2
  `hyprpaper.conf` points at `18.jpg`, `hyprlock.conf` hardcodes `17.png`. Decide policy (same image or intentionally distinct); if same, make hyprlock use the same path so the app can expose one "wallpaper" setting plus an optional lock override.
  *Accept:* documented single path (or documented intentional split); changing the wallpaper path in one place is reflected on the lock screen.

- [ ] **B3. De-duplicate eDP-1 display profile logic** — Complexity: 3
  `monitors.conf` and `scripts/hypr-display-profile.sh` carry the same per-machine eDP-1 mode/scale values with a "keep in sync" comment. Derive one from the other: have the script read its `EDP_MODE`/`EDP_SCALE` values from `monitors.conf` (or generate the `monitors.conf` eDP rule from the script's table).
  *Accept:* the eDP mode/scale value exists in exactly one file; hotplug behavior unchanged.

## C. Make hand-written configs machine-writable (highly recommended)

> Scope note: only the two hyprland.conf blocks the app actually writes are extracted — `input.conf` (C1) and the env line(s) (C2). The `appearance.conf` and `autostart.conf` splits also suggested in `dotfiles_analysis.md` §5.3 are intentionally omitted: the app edits neither window appearance nor autostart (out of v1 scope, requirements §9).

- [ ] **C1. Extract `input.conf` from hyprland.conf** — Complexity: 2
  Move the `input { }` block (kb_layout, kb_options, sensitivity, touchpad) into `config/hypr/input.conf`, `source=`d from hyprland.conf — mirroring the existing `colors.conf`/`monitors.conf` pattern. The app then owns a small, comment-light file instead of editing the monolith.
  *Accept:* `hyprctl reload` picks up input changes from the new file; hyprland.conf no longer contains an `input { }` block; keyboard layout toggle and touchpad behavior unchanged after reload.

- [ ] **C2. Consolidate hypr-side session env** — Complexity: 2
  Move the **non-cursor** `env =` lines (Qt platform theme, Ozone hints) out of hyprland.conf into a dedicated `source=`d file, or drop them in favor of `config/uwsm/env` alone. **Cursor vars are exempt:** the app writes `XCURSOR_THEME`/`XCURSOR_SIZE` to *both* a hypr-side env line and `uwsm/env` and keeps them equal (R3.4, architecture §6, tasks.md 6.4), so B1's dual location for cursor stands. If you do relocate the hypr-side cursor env into a `source=`d file, that file must be added to the app's hyprlang parser target list (architecture §3 / tasks.md 3.2) and the cursor write in tasks.md 6.4 re-pointed at it — never remove the hypr-side cursor definition outright. Depends on B1.
  *Accept:* non-cursor session env lives in exactly one location; cursor env still present in both a hypr-side file and `uwsm/env` with identical values; session comes up with an identical environment.

## D. Palette & theme pipeline hygiene (recommended)

- [ ] **D1. Document the palette schema in-repo** — Complexity: 1
  Add `colors/README.md` (or header comments in each scheme file) stating the fixed 17-key schema (`bg0–bg3 fg0–fg2 accent0–3 red orange yellow green blue purple`), bare-hex format, and that generated files must never be hand-edited.
  *Accept:* schema documented; matches what `generate-colors` validates.

- [ ] **D2. Machine-readable active-scheme marker (optional)** — Complexity: 1
  `generate-colors` already writes `# Generated from colors/<scheme> …` headers; optionally also write a stable, single-purpose state file containing just the scheme name so future detection needn't parse the header format. **Keep it out of `colors/`** — the app enumerates that directory to list selectable schemes (R3.2 / tasks.md 6.3), so a marker inside it could surface as a bogus scheme; put it in a sibling location the scheme scan never reads (e.g. a repo-level `state/active-scheme`). This is future-proofing: v1 detects the active scheme from the generated-file header (R3.2, architecture §5, tasks.md 3.7) and won't read this marker unless tasks.md 3.7 is updated to prefer it.
  *Accept:* the marker contains `everforest` after a regeneration; the header is still present; the app's scheme drop-down lists only real schemes.

- [ ] **D3. Remove stale color artifacts** — Complexity: 1
  Delete or move to `legacy/` the out-of-pipeline `config/kitty/nord.conf` and `config/polybar/colors` so theme discovery/scans never pick them up.
  *Accept:* no references to the removed files remain in active configs (`grep` clean).

## E. Optional / deferred (do not block the app)

- [ ] **E1. Font kv-source + generator extension** — Complexity: 3
  Extend the `colors/` + `generate-colors` pattern with a sibling `theme` kv file (UI font family/size) templated into kitty/eww/rofi/hyprlock, enabling a single "font" setting later. Out of app v1 scope; prep only if convenient.
  *Accept:* one kv edit + regenerate changes the font in kitty, eww, and rofi consistently.

- [ ] **E2. GTK settings.ini bootstrap** — Complexity: 1
  Add minimal `~/.config/gtk-3.0/settings.ini` / `gtk-4.0/settings.ini` (via repo + symlink or setup.sh touch) so the app's INI writer edits an existing tracked file rather than creating untracked ones.
  *Accept:* both files exist with a `[Settings]` section and current theme values; `setup.sh` links them.
