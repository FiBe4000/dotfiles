#!/usr/bin/env bash
# Sourced (not executed) by the Hyprland monitor scripts.
#
# Detects the built-in laptop panel (eDP-1) by its EDID description and derives
# the per-machine display profile FROM config/hypr/monitors.conf, which is the
# single source of truth for eDP mode/scale (Hyprland reads it natively at
# boot; this script parses the same line so hotplug/toggle re-apply identical
# values). Do NOT hardcode mode/scale here — edit the monitor= line instead.
#
# The personal laptop is keyed on its panel desc (an override rule below the
# generic eDP-1 rule); every other machine falls back to the generic eDP-1
# rule, keeping the work laptop's behavior unchanged.
#
# Exports:
#   EDP_MODE      mode string for `monitor=eDP-1,<MODE>,...`
#   EDP_SCALE     scale factor
#   EDP_EXTRA     trailing keyword args (e.g. ",bitdepth,10"), may be empty
#   EDP_LUA_EXTRA same pairs as Lua table fields (e.g. ', bitdepth = 10'), may be empty
#   EDP_DPI       Xft.dpi to use when undocked (== round(96 * scale))
# (Docked Xft.dpi is always 96 since external monitors are scale 1.0.)

# Where the authoritative monitor rules live (the deployed symlink Hyprland
# reads). Overridable for testing.
_monitors_conf="${MONITORS_CONF:-$HOME/.config/hypr/monitors.conf}"

# `monitors all` includes disabled monitors, so this works even when eDP-1 is
# currently turned off (e.g. from the toggle script).
_edp_desc="$(hyprctl monitors all -j 2>/dev/null \
    | jq -r '.[] | select(.name=="eDP-1") | .description' 2>/dev/null)"

# Map the detected panel to the monitors.conf rule key it is configured under.
case "$_edp_desc" in
    "AU Optronics 0x2036")
        # Personal laptop — own override rule keyed on its EDID desc.
        _edp_key="desc:AU Optronics 0x2036"
        ;;
    *)
        # Work laptop / anything else — generic eDP-1 rule.
        _edp_key="eDP-1"
        ;;
esac

# Pull the matching `monitor=<key>,...` rule (first non-comment match) and split
# it into  name,MODE,POS,SCALE[,EXTRA...]  — EXTRA keeps its embedded commas.
_edp_rule="$(awk -v key="$_edp_key" '
    /^[[:space:]]*#/ { next }
    {
        line = $0
        sub(/^[[:space:]]*monitor[[:space:]]*=[[:space:]]*/, "", line)
        if (line == $0) next            # not a monitor= line
        sub(/[[:space:]]*#.*$/, "", line)   # strip inline trailing comment
        if (index(line, key ",") == 1) { print line; exit }
    }
' "$_monitors_conf" 2>/dev/null)"

if [[ -n "$_edp_rule" ]]; then
    IFS=',' read -r _name EDP_MODE _pos EDP_SCALE _extra <<< "$_edp_rule"
    # Trim surrounding whitespace from the fields we keep.
    EDP_MODE="${EDP_MODE//[[:space:]]/}"
    EDP_SCALE="${EDP_SCALE//[[:space:]]/}"
    _extra="${_extra//[[:space:]]/}"
    if [[ -n "$_extra" ]]; then EDP_EXTRA=",$_extra"; else EDP_EXTRA=""; fi
    # Same trailing pairs as Lua table fields (e.g. ', bitdepth = 10') for
    # `hyprctl eval 'hl.monitor({...})'` on Lua-config sessions (Hyprland 0.55+).
    EDP_LUA_EXTRA=""
    if [[ -n "$_extra" ]]; then
        IFS=',' read -ra _kv <<< "$_extra"
        for ((_i = 0; _i + 1 < ${#_kv[@]}; _i += 2)); do
            if [[ "${_kv[_i+1]}" =~ ^[0-9.]+$ ]]; then
                EDP_LUA_EXTRA+=", ${_kv[_i]} = ${_kv[_i+1]}"
            else
                EDP_LUA_EXTRA+=", ${_kv[_i]} = \"${_kv[_i+1]}\""
            fi
        done
    fi
    # Xft.dpi tracks the scale: round(96 * scale).
    EDP_DPI="$(awk -v s="$EDP_SCALE" 'BEGIN { printf "%.0f", 96 * s }')"
else
    # Fail safe: monitors.conf unreadable or no matching rule. Come up at the
    # panel's preferred mode, unscaled — display still works, just not tuned.
    EDP_MODE="preferred"
    EDP_SCALE="1"
    EDP_EXTRA=""
    EDP_LUA_EXTRA=""
    EDP_DPI=96
fi
