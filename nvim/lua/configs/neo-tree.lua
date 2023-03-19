local M = {}

function M.config()
  local status_ok, neotree = pcall(require, "neo-tree")
  if not status_ok then
    return
  end

  vim.g.neo_tree_remove_legacy_commands = true

  neotree.setup(require("utils").user_plugin_opts("plugins.neo-tree", {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = false,
    default_component_configs = {
      indent = {
        indent_size = 2,
        padding = 0,
        with_markers = true,
        indent_marker = "|",
        last_indent_marker = "└",
        highlight = "NeoTreeIndentMarker",
        with_expanders = false,
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
        default = "",
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
      },
      git_status = {
        symbols = {
          added = "",
          deleted = "",
          modified = "",
          renamed = "➜",
          untracked = "★",
          ignored = "◌",
          unstaged = "✗",
          staged = "✓",
          conflict = "",
        },
      },
    },
    window = {
      position = "left",
      width = 25,
      -- TODO: Consider moving to global mapping location
      mappings = {
        ["o"] = "open",
        ["x"] = "open_split",
        ["s"] = "open_vsplit",
        ["c"] = "close_node",
        ["u"] = "navigate_up",
        ["."] = "set_root",
        ["H"] = "toggle_hidden",
        ["R"] = "refresh",
        ["a"] = "add",
        ["d"] = "delete",
        ["r"] = "rename",
        ["m"] = "move",
        ["q"] = "close_window"
      }
    },
    nesting_rules = {},
    filesystem = {
      -- may need to be configured by language
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          "node_modules",
          "__pycache__"
        }
      },
      follow_current_file = true,
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true
    },
    -- should this be here or with some other general events config?
    event_handlers = {
      event = "vim_buffer_enter",
      handler = function(_)
        if vim.bo.filetype == "neo-tree" then
          vim.wo.signcolumn = "auto"
        end
      end
    }
  }))
end

return M
