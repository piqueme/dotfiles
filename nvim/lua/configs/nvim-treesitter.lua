local M = {}

M.config = function()
  local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
  if not status_ok then
    return
  end

  treesitter.setup({
    ensure_installed = {},
    sync_install = false,
    ignore_install = {},
    -- highlight = {
    --   enable = true,
    --   additional_vim_regex_highlighting = false
    -- },
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

return M
