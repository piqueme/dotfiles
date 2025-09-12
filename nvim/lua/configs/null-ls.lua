local M = {}

local function concat(...)
  local args = {...}
  local output = {}
  for _, tbl in ipairs(args) do
    for k, v in pairs(tbl) do
      output[k] = v
    end
  end
  return output
end

M.config = function()
  local status_ok, null_ls = pcall(require, "null-ls")
  if not status_ok then
    print("null-ls not available.")
  end

  local diagnostic_sources = {
    null_ls.builtins.diagnostics.buf,
    null_ls.builtins.diagnostics.buildifier,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.diagnostics.jsonlint,
    null_ls.builtins.diagnostics.luacheck,
    null_ls.builtins.diagnostics.pylint,
    null_ls.builtins.diagnostics.sqlfluff.with({
        extra_args = { "--dialect", "postgres" }, -- change to your dialect
    }),
    null_ls.builtins.diagnostics.staticcheck,
    null_ls.builtins.diagnostics.yamllint,
  }

  local formatting_sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.buf,
    null_ls.builtins.formatting.buildifier,
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.sqlfluff.with({
        extra_args = { "--dialect", "postgres" }, -- change to your dialect
    }),
    null_ls.builtins.formatting.yamlfmt,
  }

  local sources = concat(diagnostic_sources, formatting_sources)

  null_ls.setup({ sources = sources })
end

return M
