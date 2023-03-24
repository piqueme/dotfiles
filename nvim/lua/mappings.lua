local M = {}

M.config = function()
  local map = vim.api.nvim_set_keymap
  local mapOpts = { noremap = true, silent = true }

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
  map("n", "<leader>ac", "<Plug>(comment_toggle_linewise_current)", mapOpts)
  map("v", "<leader>ac", "<Plug>(comment_toggle_linewise_visual)", mapOpts)

  -- GIT
  map("n", "<leader>gn", '<cmd>lua require("gitsigns").next_hunk()<CR>', mapOpts)
  map("n", "<leader>gp", '<cmd>lua require("gitsigns").prev_hunk()<CR>', mapOpts)
  map("n", "<leader>gs", '<cmd>lua require("gitsigns").stage_hunk()<CR>', mapOpts)
  map("n", "<leader>gu", '<cmd>lua require("gitsigns").undo_stage_hunk()<CR>', mapOpts)
  map("n", "<leader>gb", '<cmd>lua require("gitsigns").stage_buffer()<CR>', mapOpts)
  map("n", "<leader>gr", '<cmd>lua require("gitsigns").reset_buffer()<CR>', mapOpts)
end

return M
