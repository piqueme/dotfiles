local g = vim.g

---- bootstrap lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
print(lazypath)
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- Enable concealing, nice for files like Markdown which have noisy syntax artifacts.
vim.opt.conceallevel = 2

--- lazy.nvim plugin declarations
plugins = {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin"
  },
  -- Icons
  {
    "kyazdani42/nvim-web-devicons",
    config = function()
      require("configs.icons").config()
    end
  },
  -- Utility functions for scripting
  { 
    "nvim-lua/plenary.nvim",
    branch = "master"
  },
  -- UI component jibrary
  {
    "MunifTanjim/nui.nvim",
    commit = "c0c8e34",
    module = "nui"
  },
  -- Easy navigation between tmux panes and vim (ctrl+hjkl)
  { 
    "christoomey/vim-tmux-navigator",
    commit = "cdd66d6"
  },
  -- Language Support
  {
    "williamboman/mason.nvim",
    commit = "cd7835b"
  },
  {
    "williamboman/mason-lspconfig.nvim",
    commit = "e7b64c1"
  },
  {
    "neovim/nvim-lspconfig",
    commit = "e49b1e9",
    config = function()
      require("configs.nvim-lspconfig").config()
    end
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    commit = "0010ea9",
    config = function()
      require("configs.null-ls").config()
    end,
    lazy = true
  },
  {
    "nvim-treesitter/nvim-treesitter",
    commit = "8bc635a25",
    run = ":TSUpdate",
    config = function()
      require("configs.nvim-treesitter").config()
    end
  },
  -- High-level commenting utilities (e.g. toggle lines)
  {
    "numToStr/Comment.nvim",
    commit = "0236521",
    config = function()
      require("Comment").setup()
    end
  },
  -- Text objects for wrapping / rewrapping words in delimeters
  {
    "kylechui/nvim-surround",
    commit = "1c2ef59",
    config = function()
      require("nvim-surround").setup()
    end
  },
  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    commit = "74ce793",
    cmd = "Telescope",
    name = "telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("configs.telescope").config()
    end
  },
  {
    'echasnovski/mini.files',
    version = '*', 
    config = function()
      require("configs.minifiles").config()
    end
  },
  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    commit = "5a11682",
    event = "InsertEnter",
    name = "cmp",
    config = function()
      require("configs.nvim-cmp").config()
    end
  },
  {
    "hrsh7th/cmp-buffer",
    commit = "3022dbc",
    dependencies = { "hrsh7th/nvim-cmp" }
  },
  {
    "hrsh7th/cmp-path",
    commit = "91ff86c",
    dependencies = { "hrsh7th/nvim-cmp" }
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    commit = "99290b3",
    dependencies = { "hrsh7th/nvim-cmp" }
  },
  -- Git
  {
    "lewis6991/gitsigns.nvim",
    commit = "ff01d34",
    config = function()
      require("gitsigns").setup()
    end
  },
  -- Debugger
  {
    "mfussenegger/nvim-dap",
    commit = "1c96e487",
    -- TODO: Fix this config to not use a fixed executable!
    config = function()
      require("configs.dap").config({ executable = "/home/obe/Projects/learncpp/build/hello" })
    end
  },
  {
    "rcarriga/nvim-dap-ui", 
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    commit = "bc81f8d3",
    config = function()
      require("dapui").setup()
    end
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = {
          enabled = true
        }
      }
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    ft = { "markdown", "codecompanion" },
  },
  -- AI Support
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        -- opts = {
        --   log_level = "DEBUG",
        -- },
        strategies = {
          inline = {
            adapter = "anthropic_oneshot",
          },
          chat = {
            adapter = "anthropic_thinking",
            slash_commands = {
              ["file"] = {
                -- Location to the slash command in CodeCompanion
                callback = "strategies.chat.slash_commands.file",
                description = "Select a file using Telescope",
                opts = {
                  provider = "telescope",
                  contains_code = true,
                },
              }
            }
          },
        },
        adapters = {
          anthropic_thinking = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                -- TODO: Read this from 1password or environment.
                api_key = ""
              },
            })
          end,
          anthropic_oneshot = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                -- TODO: Read this from 1password or environment.
                api_key = ""
              },
              schema = {
                model = {
                  default = "claude-3-7-sonnet-20250219",
                },
                extended_thinking = {
                  default = false
                },
              },
            })
          end
        },
        display = {
          width = 95,
          height = 10,
          action_palette = {
            provider = "telescope",
          }
        }
      })
    end,
  },
  {
    "grpc.nvim",
    dir = "~/Projects/grpc.nvim",
    config = function()
      require("grpc").setup({})
    end
  },
}
require("lazy").setup(plugins)

-- Common options
require("configs.builtins").config()

-- Mappings
local map = vim.api.nvim_set_keymap
local mapOpts = { noremap = true, silent = true }
g.mapleader = ';'
g.maplocalleader = ';'
map("i", "jk", "<esc>", mapOpts)
map("v", "q", "<esc>", mapOpts)
map("n", "Q", "<Nop>", mapOpts)

require("mappings").config()

-- Browser
browser = require("browser")
vim.api.nvim_create_user_command("OpenURL", browser.open_url_under_cursor, {})

-- Colorscheme
local colorscheme = "catppuccin-mocha"
vim.cmd(string.format("colorscheme %s", colorscheme))
