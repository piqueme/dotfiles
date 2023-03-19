local M = {}

M.config = function()
  local status_ok, cmp = pcall(require, "cmp")
  if not status_ok then
    return
  end

  -- Prettier icons for different completion types
  local kind_icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = "",
  }

  local options = {
    preselect = cmp.PreselectMode.None,
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(_, vim_item)
        vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
        return vim_item
      end
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end
    },
    -- manage duplication, depends on other plugins
    duplicates = {
      nvim_lsp = 1,
      cmp_tabnine = 1,
      buffer = 1,
      path = 1,
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false
    },
    window = {
      -- rounded border for documentation window
      documentation = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
      }
    },
    experimental = {
      ghost_text = false,
      native_menu = false,
    },
    completion = {
      keyword_length = 1
    },
    -- depends on other plugins
    sources = {
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "path" }
    },
    mapper = {
    },
    -- could have control inverted
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
      ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
      ["<C-y>"] = cmp.config.disable,
      ["<C-e>"] = cmp.mapping {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close()
      },
      ["<CR>"] = cmp.mapping.confirm { select = true },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, {
        "i",
        "s"
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, {
        "i",
        "s"
      })
    }
  }

  cmp.setup(options)
end

return M
