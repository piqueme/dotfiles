local M = {}

-- hacky ass function to load settings from individual servers
local function setup_servers()
  path_status_ok, Path = pcall(require, 'plenary.path')
  lspconfig_status_ok, lspconfig = pcall(require, 'lspconfig')

  if not path_status_ok or not lspconfig_status_ok then
    print("Error requiring 'path' or 'lspconfig' when setting up LSP server settings.")
    return
  end

  server_setting_paths = vim.split(
    vim.fn.glob('~/.config/nvim/lua/lsp-settings/*.lua'), '\n'
  )
  for i, settings_pathname in pairs(server_setting_paths) do
    run_dir = '~/.config/nvim/lua'
    settings_path = Path:new(settings_pathname)
    normalized_settings_path = Path:new(settings_path:normalize(run_dir))
    settings_rel_path = normalized_settings_path:make_relative(run_dir)
    settings_module = string.gsub(settings_rel_path, '%.lua$', '')
    server_name = string.gsub(settings_module, 'lsp%-settings/', '')

    settings = require(settings_module)
    lspconfig[server_name].setup {
      settings = {
        [server_name] = settings
      }
    } 
  end
end


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

  setup_servers {}
end

return M
