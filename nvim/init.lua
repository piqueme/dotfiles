local g = vim.g

require("configs.builtins").config()

local colorscheme = "catppuccin-mocha"
vim.cmd(string.format("colorscheme %s", colorscheme))

-- core mappings
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

packer.startup {
  function(use)
    -- Package Manager
    use "wbthomason/packer.nvim"
    -- Boost startup time
    use {
      "nathom/filetype.nvim",
      config = function()
        vim.g.did_load_filetypes = 1
      end
    }
    -- Theme and Style
    use {
      "kyazdani42/nvim-web-devicons",
      config = function()
        require("configs.icons").config()
      end
    }
    use "EdenEast/nightfox.nvim"
    use { "catppuccin/nvim", as = "catppuccin" }
    -- Utility functions
    use { 
      "nvim-lua/plenary.nvim",
      commit = "253d348"
    }
    -- Navigation
    use { 
      "christoomey/vim-tmux-navigator",
      commit = "cdd66d6"
    }
    use { 
      "junegunn/goyo.vim", 
      commit = "fa0263d",
    }
    -- Component Library
    use {
      "MunifTanjim/nui.nvim",
      commit = "0dc148c",
      module = "nui"
    }
    -- Language Support
    use {
      "williamboman/mason.nvim",
      commit = "51228a6"
    }
    use {
      "williamboman/mason-lspconfig.nvim",
      commit = "e4badf7"
    }
    use {
      "neovim/nvim-lspconfig",
      commit = "a557dd4",
      config = function()
        require("configs.nvim-lspconfig").config()
      end
    }
    use {
      "jose-elias-alvarez/null-ls.nvim",
      commit = "456cd27",
      config = function()
        require("configs.null-ls").config()
      end
    }
    use {
      "folke/trouble.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      commit = "6733764",
      config = function()
        require("trouble").setup {}
      end
    }
    -- Syntax
    use {
      "nvim-treesitter/nvim-treesitter",
      tag = "v0.8.1",
      run = ":TSUpdate",
      config = function()
        require("configs.nvim-treesitter").config()
      end
    }
    use {
      "numToStr/Comment.nvim",
      commit = "6821b3a",
      config = function()
        require("Comment").setup()
      end
    }
    use {
      "kylechui/nvim-surround",
      commit = "8680311",
      config = function()
        require("nvim-surround").setup()
      end
    }
    -- Fuzzy Finder
    use {
      "nvim-telescope/telescope.nvim",
      commit = "a3f17d3",
      cmd = "Telescope",
      module = "telescope",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("configs.telescope").config()
      end
    }
    -- File Tree
    use {
      "nvim-neo-tree/neo-tree.nvim",
      module = "neo-tree",
      tag = "v2.42",
      cmd = "Neotree",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("configs.neo-tree").config()
      end
    }
    -- Autocomplete
    use {
      "hrsh7th/nvim-cmp",
      commit = "3192a0c57837c1ec5bf298e4f3ec984c7d2d60c0",
      event = "InsertEnter",
      module = "cmp",
      config = function()
        require("configs.nvim-cmp").config()
      end
    }
    use {
      "hrsh7th/cmp-buffer",
      commit = "3022dbc",
      after = "nvim-cmp"
    }
    use {
      "hrsh7th/cmp-path",
      commit = "91ff86c",
      after = "nvim-cmp"
    }
    use {
      "hrsh7th/cmp-nvim-lsp",
      commit = "0e6b2ed",
      after = "nvim-cmp"
    }
    -- Documentation
    use {
      "folke/which-key.nvim",
      commit = "fb02773",
      requires = {
        "nvim-telescope/telescope.nvim",
      },
      config = function()
        require('configs.which-key').config()
      end
    }
    -- Git
    use {
      "lewis6991/gitsigns.nvim",
      commit = "3b6c0a6",
      config = function()
        require("gitsigns").setup()
      end
    }
    use {
      "sindrets/diffview.nvim",
      commit = "7987d7f",
      requires = {
        "nvim-lua/plenary.nvim"
      },
      config = function()
        require("configs.diffview").config()
      end
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

require("mappings").config()
