local M = {}

function M.config()
  local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
  if not gitsigns_ok then
    vim.notify("Failed to load gitsigns dependency", vim.log.levels.WARN)
    return
  end
  require("gitsigns")

  gitsigns.setup({
    on_attach = function(bufnr)
      local gitsigns_ready = require("gitsigns")
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({']c', bang = true})
        else
          gitsigns_ready.next_hunk()
        end
      end)

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({'[c', bang = true})
        else
          gitsigns_ready.prev_hunk()
        end
      end)

      map('n', '<leader>hs', gitsigns_ready.stage_hunk)
      map('n', '<leader>hr', gitsigns_ready.reset_hunk)
      map('n', '<leader>hS', gitsigns_ready.stage_buffer)
      map('n', '<leader>hR', gitsigns_ready.reset_buffer)
      map('n', '<leader>hb', function()
        gitsigns_ready.blame_line({ full = true })
      end)
    end
  })
end

return M
