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
    highlight = {
      enable = { "markdown", "markdown_inline", "json", "go" },
      additional_vim_regex_highlighting = false
    },
  })
end

return M
