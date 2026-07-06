#!/usr/bin/env bash
# Sourced (not executed) by the Hyprland monitor scripts.
#
# Detects the built-in laptop panel (eDP-1) by its EDID description and sets
# the per-machine display profile. This keeps the work laptop's behavior
# identical while giving the personal laptop its own mode/scale/DPI.
#
# Exports:
#   EDP_MODE      mode string for `monitor=eDP-1,<MODE>,...`
#   EDP_SCALE     scale factor
#   EDP_EXTRA     trailing keyword args (e.g. ",bitdepth,10"), may be empty
#   EDP_DPI       Xft.dpi to use when undocked (== round(96 * scale))
# (Docked Xft.dpi is always 96 since external monitors are scale 1.0.)

# `monitors all` includes disabled monitors, so this works even when eDP-1 is
# currently turned off (e.g. from the toggle script).
_edp_desc="$(hyprctl monitors all -j 2>/dev/null \
    | jq -r '.[] | select(.name=="eDP-1") | .description' 2>/dev/null)"

case "$_edp_desc" in
    "AU Optronics 0x2036")
        # Personal laptop — 2560x1440 panel, 1.066667x (2400x1350 logical,
        # only blur-free step between native and 1.25)
        EDP_MODE="2560x1440@60"
        EDP_SCALE="1.066667"
        EDP_EXTRA=""
        EDP_DPI=102
        ;;
    *)
        # Work laptop (default / fallback) — 2880x1800 120Hz, 10-bit, 1.333x
        EDP_MODE="2880x1800@120"
        EDP_SCALE="1.333333"
        EDP_EXTRA=",bitdepth,10"
        EDP_DPI=128
        ;;
esac
