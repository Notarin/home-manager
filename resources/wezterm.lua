local wezterm = require 'wezterm'

return {
    harfbuzz_features = { 'cv12' },
    bold_brightens_ansi_colors = true,
    set_environment_variables = {
        LANG = "en_US.UTF-8",
    },
    window_decorations = "NONE",
    enable_tab_bar = true,
    use_fancy_tab_bar = false,
    hide_tab_bar_if_only_one_tab = true,
    show_close_tab_button_in_tabs = false,
    show_tab_index_in_tab_bar = false,
    show_new_tab_button_in_tab_bar = false,
    window_padding = {
        left = '0cell',
        right = '0cell',
        top = '0cell',
        bottom = '0cell',
    },
    window_frame = {
        font = wezterm.font { family = 'Firacode Nerd Font', weight = 'Bold' },
        font_size = 12.0,
    },
    enable_wayland = true,
    adjust_window_size_when_changing_font_size = false,
    enable_kitty_graphics = true,
    window_close_confirmation = "NeverPrompt",
    keys = {
        {
            mods = "CTRL",
            key = "c",
            action = wezterm.action_callback(function(window, pane)
                local has_selection = window:get_selection_text_for_pane(pane) ~= ""
                if has_selection then
                    window:perform_action(
                        wezterm.action { CopyTo = "ClipboardAndPrimarySelection" },
                        pane)
                    window:perform_action("ClearSelection", pane)
                else
                    window:perform_action(
                        wezterm.action { SendKey = { key = "c", mods = "CTRL" } },
                        pane)
                end
            end)
        },
        { mods = "CTRL", key = "v",          action = wezterm.action.PasteFrom 'Clipboard' },
        { mods = 'ALT',  key = 'Enter',      action = wezterm.action.DisableDefaultAssignment, },
        { mods = 'CTRL', key = 'Enter',      action = wezterm.action.SendKey { key = '/', mods = "CTRL" }, },
        { mods = "CTRL", key = "t",          action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
        { mods = "CTRL", key = "w",          action = wezterm.action.CloseCurrentTab { confirm = false } },
        { mods = 'ALT',  key = 'h',          action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
        { mods = 'ALT',  key = 'v',          action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
        { mods = 'ALT',  key = 'LeftArrow',  action = wezterm.action.ActivatePaneDirection 'Left', },
        { mods = 'ALT',  key = 'RightArrow', action = wezterm.action.ActivatePaneDirection 'Right', },
        { mods = 'ALT',  key = 'UpArrow',    action = wezterm.action.ActivatePaneDirection 'Up', },
        { mods = 'ALT',  key = 'DownArrow',  action = wezterm.action.ActivatePaneDirection 'Down', },
        { mods = 'ALT',  key = 'w',          action = wezterm.action.CloseCurrentPane { confirm = false }, },
    },
    unix_domains = {
        {
            name = 'default',
        },
    },
    --default_gui_startup_args = { 'connect', 'default' },
}