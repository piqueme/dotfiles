-- depends on 'gitsigns'
-- depends on 'diffview'
-- depends on 'telescope'
-- depends on 'fugitive'
local M = {}

-- See PRs I need to review
  -- show assignee (me or group)
  -- select in Telescope by message
  -- open in DiffView (against base branch)
  -- ideally can see comments in gutter
  -- ideally can toggle a floating window on a comment line and add comment
  -- ALTERNATE
  --  see PRs to review in terminal
  --  copy paste hash

function M.config()
  local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
  local diffview_ok, diffview = pcall(require, "diffview")
  local telescope_ok, telescope = pcall(require, "telescope")

  -- gitsigns has a lot of functionality, but largely used for highlighting changes in the gutter
  -- FUNC: motions between hunks
  -- FUNC: select hunk
  -- FUNC: prev / next hunk
  -- FUNC: stage / unstage hunk
  -- FUNC: reset hunk
  gitsigns.setup {
    -- May be helpful to tune per-project for performance
    watch_gitdir = {
      interval = 1000,
      follow_files = true
    },
    update_debounce = 100,
    max_file_length = 10000,
    on_attach = function(bufnr)
      local mapOpts = { noremap = true, silent = true }
      -- TODO: Load mappings from some module table object, centralized map options
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gn', '<cmd>lua require"gitsigns".next_hunk()<CR>', mapOpts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gp', '<cmd>lua require"gitsigns".prev_hunk()<CR>', mapOpts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ga', '<cmd>lua require"gitsigns".stage_hunk()<CR>', mapOpts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gu', '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>', mapOpts)
    end
    -- TODO: could be used to set status line info (like +/-, branch name)
  }

  -- normal diff mode
  -- get / put between buffers
  
  -- diffview
  -- useful for scanning multi-file changesets
  -- FUNC: View all changes between commits or index / close
  -- TODO: Figure out use as merge tool
  
  -- telescope is useful for jumping around
  -- FUNC: See file history with commit hash + message + author + time, preview (diff), action checkout / reset / diff
  -- FUNC: See repo history, preview (diff-stat), action checkout / diffview / reset
  -- FUNC: See branches, preview (diff-stat w/ master), action checkout / delete
  -- FUNC: See status [cut 1], hunks [cut 2]
  -- Special
  --  for file history -> open vdiffsplit from fugitive
  --  for repo history -> show diffstat in preview
  --  for repo history -> add diffopen option
  --  customizing preview (https://github.com/nvim-telescope/telescope.nvim/issues/605)
  -- Actions
  --  file history -> [enter] diffsplit, [;c | <C-c>] checkout
  --  repo history -> [enter] checkout, [;d | <C-d>] diff
  --  branches -> [enter] checkout, [;d | <C-d>] diff
end

return M
