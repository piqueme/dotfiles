local M = {}

M.config = function(opts) 
  local status_ok, dap = pcall(require, "dap")
  if not status_ok then
    print("nvim-dap not available.")
  end

  -- Configure CMake debug adapter
  dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = "gdb",
    args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
  }

  -- Debug configuration for CMake projects
  dap.configurations.cpp = {
    {
      name = "CPP Debug",
      type = "cppdbg",
      request = "launch",
      program = function()
        -- Automatically find the executable in the build directory
        return opts.executable
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = true,
    }
  }

  local dapui_status_ok, dapui = pcall(require, "dapui")
  if not dapui_status_ok then
    print("nvim-dap-ui not available, not configuring debugger UI.")
  end

  -- Sets listeners so that the debugger UI opens and closes
  -- as we start / close debug sessions.
  dap.listeners.before.attach.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.launch.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
  end
  dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
  end
end

return M
