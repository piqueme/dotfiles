local M = {}

M.config = function()
  local status_ok, mini = pcall(require, "mini.files")
  if not status_ok then
    return
  end

  mini.setup()
end

return M
