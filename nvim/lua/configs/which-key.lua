local M = {}

M.config = function()
  local status_ok, wk = pcall(require, "which-key")
  if not status_ok then
    return
  end

  wk.setup({
    plugins = {
      marks = true,
      registers = true,
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        z = false,
        g = true
      }
    },
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+"
    },
    popup_mappings = {
      scroll_down = "<c-n>",
      scroll_up = "<c-p>",
    },
    window = {
      border = "none",
      position = "bottom",
      padding = { 2, 2, 2, 2 }
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "left"
    },
    show_help = true,
    show_keys = true
  })

  wk.register({
    f = {
      name = "file",
      f = { "<cmd>Telescope find_files<CR>", "Find File" },
      g = { "<cmd>Telescope live_grep<CR>", "Live Grep" },
      e = { "<cmd>Neotree toggle<CR>", "Toggle File Tree" },
      o = { "<cmd>Neotree focus<CR>", "Focus File Tree" },
    }
  }, { prefix = "<leader>" })
end

return M
