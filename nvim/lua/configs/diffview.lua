local M = {}

M.config = function()
  local actions = require("diffview.actions")

  require("diffview").setup({
    keymaps = {
      view = {},
      diff1 = {},
      diff2 = {},
      diff3 = {},
      diff4 = {},
      file_panel = {},
      file_history_panel = {
        { "n", "<C-o>", actions.open_in_diffview, { desc = "Open the entry under the cursor in a diffview" } },
      },
      option_panel = {},
      help_panel = {},
    }
  })
end

return M
