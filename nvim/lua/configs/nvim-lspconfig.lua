local M = {}

M.config = function()
  local mason_status_ok, mason = pcall(require, "mason")
  local mason_lsp_status_ok, masonlsp = pcall(require, "mason-lspconfig")
  local status_ok, lspconfig = pcall(require, "lspconfig")

  if not status_ok or not mason_status_ok or not mason_lsp_status_ok then
    print(status_ok)
    return
  end

  mason.setup()
  masonlsp.setup()


  -- define nicer diagnostic signs in gutter (cosmetic)
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end
  -- enables popup window with diagnostic details on goto
  local diagnosticConfig = {
    virtual_text = true,
    signs = { active = signs },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = ""
    }
  }
  vim.diagnostic.config(diagnosticConfig)

  -- "Hover" handler window tweaks
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded"
  })

  -- "Signature" handler window tweaks
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded"
  })

  -- extend LSP settings for different language servers
  lspconfig.gopls.setup {}
  -- lsp_installer.on_server_ready(function(server)
  --   local opts = server:get_default_options()
  --   local present, serverConfig = pcall(require, "test.servers." .. server.name)
  --   if present then
  --     opts = vim.tbl_deep_extend("force", serverConfig, opts)
  --   end
  --   server:setup(opts)
  -- end)
end

return M
