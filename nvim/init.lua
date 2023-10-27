local g = vim.g

--- bootstrap lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

--- lazy.nvim plugin declarations
plugins = {
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
    commit = "5001291"
  },
  -- UI component library
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
  -- Syntax
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   tag = "v0.8.1",
  --   run = ":TSUpdate",
  --   config = function()
  --     require("configs.nvim-treesitter").config()
  --   end
  -- }
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
  -- File Tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    name = "neo-tree",
    commit = "63ebe87",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("configs.neo-tree").config()
    end
  },
  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    commit = "5dce1b7",
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
    commit = "44b16d1",
    dependencies = { "hrsh7th/nvim-cmp" }
  },
  {
    "folke/which-key.nvim",
    commit = "fc25407",
    config = function()
      require('configs.which-key').config()
    end,
  },
  -- Git
  {
    "lewis6991/gitsigns.nvim",
    commit = "ff01d34",
    config = function()
      require("gitsigns").setup()
    end
  },
  {
    "sindrets/diffview.nvim",
    commit = "0437ef8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("configs.diffview").config()
    end,
    lazy = true,
    cmd = {
      "DiffviewFileHistory",
      "DiffviewOpen",
    }
  }
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

-- Colorscheme
local colorscheme = "catppuccin-mocha"
vim.cmd(string.format("colorscheme %s", colorscheme))
