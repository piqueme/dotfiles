local M = {}

function M.open_url_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  -- Pattern to match URLs
  local url_pattern = "[a-zA-Z]+://[%w-_%.%?%.:/%+=&]+"

  -- Search for URL in the current line
  for url in line:gmatch(url_pattern) do
    vim.print("Line " .. line .. url)
    local start_idx, end_idx = line:find(url, 1, true)
    if col >= start_idx and col <= end_idx then
      vim.fn.jobstart({ "xdg-open", url }, { detach = true }) -- Linux
      vim.defer_fn(
        function()
          vim.fn.jobstart({ "i3-msg", "[class=\"Firefox\"] focus" }, { detach = true })
        end, 1000
      ) -- Delay to allow time for the browser to launch
      return
    end
  end
end

return M

-- Create a command and keybinding
-- vim.api.nvim_create_user_command("OpenURL", open_url_under_cursor, {})
