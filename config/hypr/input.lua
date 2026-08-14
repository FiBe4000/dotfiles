-- Input configuration (keyboard layout/options, sensitivity, touchpad)
-- Loaded by hyprland.lua via dofile. App-owned: written by the settings app;
-- keep it small and schema-flat (one hl.config call, no logic).
hl.config({
    input = {
        kb_layout = "us,se",
        kb_options = "grp:win_space_toggle,caps:escape",

        sensitivity = 0.3,
        follow_mouse = 1,

        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
            scroll_factor = 1.0,
        },
    },
})
