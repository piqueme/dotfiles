local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Catppuccin Mocha'
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 16

-- Don't work with multiple tabs in Wezterm. Let the tiling window manager handle all "window-like" object management.
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true

-- This notification is way too noisy for a minor offence.
config.warn_about_missing_glyphs=false

-- Disable default keybindings. We like total control over the keyboard - it
-- is difficult to maintain control over all program keyboards when each program
-- is implicitly defining its own keys.
config.disable_default_key_bindings = true

-- Generic key mappings.
config.keys = {
  {
    key = 'm',
    mods = 'CTRL',
    action = wezterm.action.TogglePaneZoomState,
  },
  {
    key = 'p',
    mods = 'CTRL',
    action = wezterm.action.ActivateCommandPalette,
  },
  {
    key = 'h',
    mods = 'CTRL',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'CTRL',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'o',
    mods = 'CTRL',
    action = wezterm.action.SplitHorizontal,
  },
  {
    key = '-',
    mods = 'CTRL',
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = '+',
    mods = 'CTRL',
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = 'V',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
  {
    key = 'C',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CopyTo 'Clipboard',
  },
  {
    key = 'i',
    mods = 'CTRL',
    action = wezterm.action.Search { CaseInSensitiveString = '' },
  },
  {
    key = ';',
    mods = 'CTRL',
    action = wezterm.action.ActivateCopyMode,
  },
}

config.key_tables = {
  search_mode = {
    {
      key = 'n',
      mods = 'CTRL',
      action = wezterm.action.CopyMode 'NextMatch',
    },
    {
      key = 'p',
      mods = 'CTRL',
      action = wezterm.action.CopyMode 'PriorMatch',
    },
    {
      key = 'c',
      mods = 'CTRL',
      action = wezterm.action.CopyMode 'Close',
    },
  },
  copy_mode = {
    {
      key = '>',
      mods = 'CTRL',
      action = wezterm.action.CopyMode 'MoveToEndOfLineContent',
    },
    {
      key = '<',
      mods = 'CTRL',
      action = wezterm.action.CopyMode 'MoveToStartOfLine',
    },
    {
      key = 'c',
      mods = 'CTRL',
      action = wezterm.action.Multiple {
        'ScrollToBottom',
        { CopyMode = 'Close' },
      }
    },
    {
      key = 'v',
      mods = 'SHIFT',
      action = wezterm.action.CopyMode { SetSelectionMode = 'Line' },
    },
    {
      key = 'h',
      mods = 'NONE',
      action = wezterm.action.CopyMode 'MoveLeft',
    },
    {
      key = 'j',
      mods = 'NONE',
      action = wezterm.action.CopyMode 'MoveDown',
    },
    {
      key = 'k',
      mods = 'NONE',
      action = wezterm.action.CopyMode 'MoveUp',
    },
    {
      key = 'l',
      mods = 'NONE',
      action = wezterm.action.CopyMode 'MoveRight',
    },
    {
      key = 'y',
      mods = 'NONE',
      action = wezterm.action.Multiple {
        { CopyTo = 'ClipboardAndPrimarySelection' },
        'ScrollToBottom',
        { CopyMode = 'Close' },
      },
    },
  },
}

return config
