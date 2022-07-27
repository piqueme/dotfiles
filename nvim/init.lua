local g = vim.g

-- disable builtins
g.loaded_2html_plugin = false
g.loaded_getscript = false
g.loaded_getscriptPlugin = false
g.loaded_gzip = false
g.loaded_logipat = false
g.loaded_netrwFileHandlers = false
g.loaded_netrwPlugin = false
g.loaded_netrwSettngs = false
g.loaded_remote_plugins = false
g.loaded_tar = false
g.loaded_tarPlugin = false
g.loaded_zip = false
g.loaded_zipPlugin = false
g.loaded_vimball = false
g.loaded_vimballPlugin = false
g.zipPlugin = false

-- core settings
local set = vim.opt

local colorscheme = "nightfox"
vim.cmd(string.format("colorscheme %s", colorscheme))

set.autoread = true -- when switching back to Neovim, file is re-read for updates
set.fileencoding = "utf-8" -- File content encoding for the buffer
set.spelllang = "en" -- Support US english
set.clipboard = "unnamedplus" -- Connection to the system clipboard
set.signcolumn = "yes" -- Always show the sign column
set.foldmethod = "manual" -- Create folds manually
set.completeopt = { "menuone", "noselect" } -- Options for insert mode completion
set.colorcolumn = "99999" -- Fix for the indentline problem
set.backup = false -- Disable making a backup file
set.expandtab = true -- Enable the use of space in tab
set.hidden = true -- Ignore unsaved buffers
set.hlsearch = true -- Highlight all the matches of search pattern
set.ignorecase = true -- Case insensitive searching
set.smartcase = true -- Case sensitivie searching
set.spell = false -- Disable spelling checking and highlighting
set.showmode = false -- Disable showing modes in command line
set.smartindent = true -- Do auto indenting when starting a new line
set.splitbelow = true -- Splitting a new window below the current one
set.splitright = true -- Splitting a new window at the right of the current one
set.swapfile = false -- Disable use of swapfile for the buffer
set.termguicolors = true -- Enable 24-bit RGB color in the TUI
set.undofile = true -- Enable persistent undo
set.writebackup = false -- Disable making a backup before overwriting a file
set.cursorline = true -- Highlight the text line of the cursor
set.number = true -- Show numberline
set.wrap = false -- Disable wrapping of lines longer than the width of window
set.conceallevel = 0 -- Show text normally
set.cmdheight = 1 -- Number of screen lines to use for the command line
set.shiftwidth = 2 -- Number of space inserted for indentation
set.tabstop = 2 -- Number of space in a tab
set.scrolloff = 8 -- Number of lines to keep above and below the cursor
set.sidescrolloff = 8 -- Number of columns to keep at the sides of the cursor
set.pumheight = 10 -- Height of the pop up menu
set.history = 100 -- Number of commands to remember in a history table
set.timeoutlen = 300 -- Length of time to wait for a mapped sequence
set.updatetime = 300 -- Length of time to wait before triggering the plugin

-- basic mappings
local map = vim.api.nvim_set_keymap
local mapOpts = { noremap = true, silent = true }
g.mapleader = ';'
g.maplocalleader = ';'
map("i", "jk", "<esc>", mapOpts)
map("v", "q", "<esc>", mapOpts)
map("n", "Q", "<Nop>", mapOpts)

local packer_status_ok, packer = pcall(require, "packer")
if not packer_status_ok then
  error("Failed to load Packer!")
end

local packer_config = {
  compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end
  },
  profile = {
    enable = true,
    threshold = 0.0001,
  },
  git = {
    clone_timeout = 300
  },
  auto_clean = true,
  compile_on_sync = true
}

local lsp_config = function()
  local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
  if not status_ok then
    print(status_ok)
    return
  end

  -- define nicer diagnostic signs in gutter (cosmetic)
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end
  -- enables popup window with diagnostic details on goto
  local diagnosticConfig = {
    virtual_text = true,
    signs = { active = signs },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = ""
    }
  }
  vim.diagnostic.config(diagnosticConfig)

  -- "Hover" handler window tweaks
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded"
  })

  -- "Signature" handler window tweaks
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded"
  })

  -- extend LSP settings for different language servers
  lsp_installer.on_server_ready(function(server)
    local opts = server:get_default_options()
    local present, serverConfig = pcall(require, "test.servers." .. server.name)
    if present then
      opts = vim.tbl_deep_extend("force", serverConfig, opts)
    end
    server:setup(opts)
  end)
end

local symbols_outline_config = function()
  -- NOTE: Not sure the preview is necessary
  -- NOTE: Width could be smaller
  vim.g.symbols_outline = {
    highlight_hovered_item = true,
    show_guides = true,
    auto_preview = true,
    position = "right",
    relative_width = true,
    width = 35,
    auto_close = false,
    show_numbers = false,
    show_relative_numbers = false,
    show_symbol_details = true,
    preview_bg_highlight = "Pmenu",
    keymaps = {
      close = { "<Esc>", "q" },
      goto_location = "<Cr>",
      focus_location = "o",
      hover_symbol = "<C-space>",
      toggle_preview = "K",
      rename_symbol = "r",
      code_actions = "a",
    },
    lsp_blacklist = {},
    symbol_blacklist = {},
    symbols = {
      File = { icon = "", hl = "TSURI" },
      Module = { icon = "", hl = "TSNamespace" },
      Namespace = { icon = "", hl = "TSNamespace" },
      Package = { icon = "", hl = "TSNamespace" },
      Class = { icon = "𝓒", hl = "TSType" },
      Method = { icon = "ƒ", hl = "TSMethod" },
      Property = { icon = "", hl = "TSMethod" },
      Field = { icon = "", hl = "TSField" },
      Constructor = { icon = "", hl = "TSConstructor" },
      Enum = { icon = "ℰ", hl = "TSType" },
      Interface = { icon = "ﰮ", hl = "TSType" },
      Function = { icon = "", hl = "TSFunction" },
      Variable = { icon = "", hl = "TSConstant" },
      Constant = { icon = "", hl = "TSConstant" },
      String = { icon = "𝓐", hl = "TSString" },
      Number = { icon = "#", hl = "TSNumber" },
      Boolean = { icon = "⊨", hl = "TSBoolean" },
      Array = { icon = "", hl = "TSConstant" },
      Object = { icon = "⦿", hl = "TSType" },
      Key = { icon = "🔐", hl = "TSType" },
      Null = { icon = "NULL", hl = "TSType" },
      EnumMember = { icon = "", hl = "TSField" },
      Struct = { icon = "𝓢", hl = "TSType" },
      Event = { icon = "🗲", hl = "TSType" },
      Operator = { icon = "+", hl = "TSOperator" },
      TypeParameter = { icon = "𝙏", hl = "TSParameter" },
    },
  }
end

local treesitter_config = function()
  local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
  if not status_ok then
    return
  end

  treesitter.setup({
    ensure_installed = {},
    sync_install = false,
    ignore_install = {},
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["am"] = "@block.outer",
          ["im"] = "@block.inner"
        }
      },
      move = {
        enable = true,
        goto_next_start = {
          ["]f"] = "@function.outer",
          ["]a"] = "@parameter.outer",
        },
        goto_prev_start = {
          ["[f"] = "@function.outer",
          ["[a"] = "@parameter.outer",
        },
      }
    }
  })
end

local telescope_config = function()
  local status_ok, telescope = pcall(require, "telescope")
  if not status_ok then
    return
  end

  local actions = require "telescope.actions"

  local options = {
    defaults = {
      prompt_prefix = " ",
      selection_caret = "❯ ",
      path_display = { "truncate" },
      selection_strategy = "reset",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
          results_width = 0.8
        },
        vertical = {
          mirror = false
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120
      },
      mappings = {
        i = {
          ["<C-n>"] = actions.move_selection_next,
          ["<C-p>"] = actions.move_selection_previous,
          ["<C-c>"] = actions.close,
          ["<CR>"] = actions.select_default,
          ["<C-x>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down
        },
        n = {
          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["q"] = actions.close,
          ["<CR>"] = actions.select_default,
          ["<C-x>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down
        }
      },
    },
    pickers = {},
    extensions = {}
  }

  telescope.setup(options)
end

local neotree_config = function()
  local status_ok, neotree = pcall(require, "neo-tree")
  if not status_ok then
    return
  end

  vim.g.neo_tree_remove_legacy_commands = true

  neotree.setup(require("core.utils").user_plugin_opts("plugins.neo-tree", {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = false,
    default_component_configs = {
      indent = {
        indent_size = 2,
        padding = 0,
        with_markers = true,
        indent_marker = "|",
        last_indent_marker = "└",
        highlight = "NeoTreeIndentMarker",
        with_expanders = false,
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
        default = "",
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
      },
      git_status = {
        symbols = {
          added = "",
          deleted = "",
          modified = "",
          renamed = "➜",
          untracked = "★",
          ignored = "◌",
          unstaged = "✗",
          staged = "✓",
          conflict = "",
        },
      },
    },
    window = {
      position = "left",
      width = 25,
      -- TODO: Consider moving to global mapping location
      mappings = {
        ["o"] = "open",
        ["x"] = "open_split",
        ["s"] = "open_vsplit",
        ["c"] = "close_node",
        ["u"] = "navigate_up",
        ["."] = "set_root",
        ["H"] = "toggle_hidden",
        ["R"] = "refresh",
        ["a"] = "add",
        ["d"] = "delete",
        ["r"] = "rename",
        ["m"] = "move",
        ["q"] = "close_window"
      }
    },
    nesting_rules = {},
    filesystem = {
      -- may need to be configured by language
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          "node_modules",
          "__pycache__"
        }
      },
      follow_current_file = true,
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true
    },
    -- should this be here or with some other general events config?
    event_handlers = {
      event = "vim_buffer_enter",
      handler = function(_)
        if vim.bo.filetype == "neo-tree" then
          vim.wo.signcolumn = "auto"
        end
      end
    }
  }))
end

local cmp_setup = function()
  local status_ok, cmp = pcall(require, "cmp")
  if not status_ok then
    return
  end

  -- Prettier icons for different completion types
  local kind_icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = "",
  }

  local options = {
    preselect = cmp.PreselectMode.None,
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(_, vim_item)
        vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
        return vim_item
      end
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end
    },
    -- manage duplication, depends on other plugins
    duplicates = {
      nvim_lsp = 1,
      cmp_tabnine = 1,
      buffer = 1,
      path = 1,
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false
    },
    window = {
      -- rounded border for documentation window
      documentation = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
      }
    },
    experimental = {
      ghost_text = false,
      native_menu = false,
    },
    completion = {
      keyword_length = 1
    },
    -- depends on other plugins
    sources = {
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "path" }
    },
    mapper = {
    },
    -- could have control inverted
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
      ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
      ["<C-y>"] = cmp.config.disable,
      ["<C-e>"] = cmp.mapping {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close()
      },
      ["<CR>"] = cmp.mapping.confirm { select = true },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, {
        "i",
        "s"
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, {
        "i",
        "s"
      })
    }
  }

  cmp.setup(options)
end

packer.startup {
  function(use)
    -- Package Manager
    use "wbthomason/packer.nvim"
    -- Utility functions
    use "nvim-lua/plenary.nvim"
    -- Component Library
    use {
      "MunifTanjim/nui.nvim",
      module = "nui"
    }
    -- Icons
    use {
      "kyazdani42/nvim-web-devicons",
      config = function()
        require("configs.icons").config()
      end
    }
    -- PERFORMANCE
    -- Boost startup time
    use {
      "nathom/filetype.nvim",
      config = function()
        vim.g.did_load_filetypes = 1
      end
    }
    use {
      "antoinemadec/FixCursorHold.nvim",
      config = function()
        vim.g.cursorhold_updatetime = 100
      end
    }
    -- LSP (TODO: Lazy load LSP, not sure why BufRead doesn't work)
    use {
      "williamboman/nvim-lsp-installer",
      module = "nvim-lsp-installer",
      cmd = {
        "LspInstall",
        "LspInstallInfo",
        "LspPrintInstalled",
        "LspRestart",
        "LspStart", "LspStop",
        "LspUninstall",
        "LspUninstallAll"
      }
    }
    use {
      "neovim/nvim-lspconfig",
      config = lsp_config
    }
    use {
      "simrat39/symbols-outline.nvim",
      cmd = "SymbolsOutline",
      setup = symbols_outline_config,
    }
    -- Syntax
    use {
      "nvim-treesitter/nvim-treesitter",
      commit = "94255915e659b83e8c57fd2ec0d6791995326f66",
      run = ":TSUpdate",
      config = treesitter_config,

    }
    use { "nvim-treesitter/nvim-treesitter-textobjects" }
    use {
      "numToStr/Comment.nvim",
      tag = "v0.6",
      config = function()
        require("Comment").setup()
      end
    }
    -- Fuzzy Finder
    use {
      "nvim-telescope/telescope.nvim",
      tag = "nvim-0.6",
      cmd = "Telescope",
      module = "telescope",
      requires = "nvim-lua/plenary.nvim",
      config = telescope_config
    }
    -- Colorscheme
    use "EdenEast/nightfox.nvim"
    -- Utility
    use { "christoomey/vim-tmux-navigator" }
    -- File Tree
    use {
      "nvim-neo-tree/neo-tree.nvim",
      module = "neo-tree",
      cmd = "Neotree",
      requires = "MunifTanjim/nui.nvim",
      config = neotree_config,
    }
    use "L3MON4D3/LuaSnip"
    -- Autocomplete
    use {
      "hrsh7th/nvim-cmp",
      commit = "3192a0c57837c1ec5bf298e4f3ec984c7d2d60c0",
      event = "InsertEnter",
      module = "cmp",
      config = cmp_setup
    }
    use {
      "hrsh7th/cmp-buffer",
      after = "nvim-cmp"
    }
    use {
      "hrsh7th/cmp-path",
      after = "nvim-cmp"
    }
    use {
      "saadparwaiz1/cmp_luasnip",
      after = "nvim-cmp"
    }
    use {
      "hrsh7th/cmp-nvim-lsp",
      after = "nvim-cmp"
    }
  end,
  config = packer_config
}
packer.compile()

vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerCompile
  augroup end
]]

-- INTELLIGENCE
map("n", "<leader>id", "<cmd>lua vim.lsp.buf.definition()<CR>", mapOpts)
map("n", "<leader>it", "<cmd>lua vim.lsp.buf.type_definition()<CR>", mapOpts)
map("n", "<leader>ip", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', mapOpts)
map("n", "<leader>in", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', mapOpts)
map("n", "<leader>ie", '<cmd>lua vim.diagnostic.open_float()<CR>', mapOpts)
map("n", "<leader>if", "<cmd>lua vim.lsp.buf.formatting_sync()<cr>", mapOpts)
map("n", "<leader>ia", "<cmd>lua vim.lsp.buf.code_action()<cr>", mapOpts)
map("n", "<leader>ic", "<cmd>lua vim.lsp.buf.rename()<cr>", mapOpts)
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", mapOpts)
-- NOTE: Depend on symbols-outline
map("n", "<leader>io", "<cmd>SymbolsOutline<CR>", mapOpts)
-- NOTE: Depend on Telescope
map("n", "<leader>is", "<cmd>Telescope lsp_document_symbols<CR>", mapOpts)
map("n", "<leader>ir", "<cmd>Telescope lsp_references<CR>", mapOpts)

-- SYSTEM
local configLocation = vim.fn.stdpath "config" .. "/init.lua"
map("n", "<leader>se", "<cmd>edit " .. configLocation .. "<CR>", mapOpts)
map("n", "<leader>ss", "<cmd>source " .. configLocation .. "<CR>", mapOpts)
map("n", "<leader>si", "<cmd>PackerInstall<CR>", mapOpts)
map("n", "<leader>su", "<cmd>PackerSync<CR>", mapOpts)
-- NOTE: Depends on Telescope
map("n", "<leader>sc", "<cmd>Telescope commands<CR>", mapOpts)
map("n", "<leader>sh", "<cmd>Telescope help_tags<CR>", mapOpts)

-- BUFFER MANAGEMENT
map("n", "<leader>ba", "<cmd>b#<CR>", mapOpts)
map("n", "<leader>bn", "<cmd>bnext<CR>", mapOpts)
map("n", "<leader>bp", "<cmd>bprev<CR>", mapOpts)
map("n", "<leader>bw", "<cmd>wq<CR>", mapOpts)
map("n", "<leader>bq", "<cmd>q<CR>", mapOpts)
map("n", "<leader>bs", "<cmd>w<CR>", mapOpts)
-- NOTE: Depend on Telescope
map("n", "<leader>bf", "<cmd>Telescope buffers<CR>", mapOpts)

-- FILE AND STRING NAVIGATION
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", mapOpts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", mapOpts)
map("n", "<leader>fe", "<cmd>Neotree toggle<CR>", mapOpts)
map("n", "<leader>fo", "<cmd>Neotree focus<CR>", mapOpts)

-- ANNOTATION AND DOCUMENTATION
map("n", "<leader>ac", "<cmd>lua require('Comment.api').toggle_current_linewise()<cr>", mapOpts)
map("v", "<leader>ac", "<esc><cmd>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>", mapOpts)

-- TODO: Intelligence: Code Action + Rename Hover Window
-- TODO: Plugin and Function Toggles
-- TODO: Text Objects (function, condition, block, argument, surround)
-- TODO: Notifications?
-- TODO: Autocompletion (including Snippets)
