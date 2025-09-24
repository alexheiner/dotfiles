local function rebuild_project(co, path)
  local spinner = require("easy-dotnet.ui-modules.spinner").new()
  spinner:start_spinner("Building")
  vim.fn.jobstart(string.format("dotnet build %s", path), {
    on_exit = function(_, return_code)
      if return_code == 0 then
        spinner:stop_spinner("Built successfully")
      else
        spinner:stop_spinner("Build failed with exit code " .. return_code, vim.log.levels.ERROR)
        error("Build failed")
      end
      coroutine.resume(co)
    end,
  })
  coroutine.yield()
end

return {
  "mfussenegger/nvim-dap",
  enabled = false,
  config = function()
    local dap = require("dap")
    local dotnet = require("easy-dotnet")
    local dapui = require("dapui")
    dap.set_log_level("TRACE")

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

    vim.keymap.set("n", "q", function()
      dap.close()
      dapui.close()
    end, {})

    vim.keymap.set("n", "<F5>", dap.continue, {})
    vim.keymap.set("n", "<F10>", dap.step_over, {})
    vim.keymap.set("n", "<leader>dO", dap.step_over, {})
    vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, {})
    vim.keymap.set("n", "<leader>dr", dap.repl.toggle, {})
    vim.keymap.set("n", "<leader>dj", dap.down, {})
    vim.keymap.set("n", "<leader>dk", dap.up, {})
    vim.keymap.set("n", "<F11>", dap.step_into, {})
    vim.keymap.set("n", "<F12>", dap.step_out, {})
    vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<F2>", require("dap.ui.widgets").hover, {})

    local function file_exists(path)
      local stat = vim.loop.fs_stat(path)
      return stat and stat.type == "file"
    end

    local debug_dll = nil

    local function ensure_dll()
      if debug_dll ~= nil then
        return debug_dll
      end
      local dll = dotnet.get_debug_dll()
      debug_dll = dll
      return dll
    end

    for _, value in ipairs({ "cs", "fsharp" }) do
      dap.configurations[value] = {
        {
          type = "coreclr",
          name = "Program",
          request = "launch",
          env = function()
            local dll = ensure_dll()
            local vars = dotnet.get_environment_variables(dll.project_name, dll.absolute_project_path, false)
            return vars or nil
          end,
          program = function()
            local dll = ensure_dll()
            local co = coroutine.running()
            rebuild_project(co, dll.project_path)
            if not file_exists(dll.target_path) then
              error("Project has not been built, path: " .. dll.target_path)
            end
            print("Debugging: " .. dll.target_path)
            return dll.target_path
          end,
          cwd = function()
            local dll = ensure_dll()
            print("CWD: " .. dll.absolute_project_path)
            return dll.absolute_project_path
          end,
        },
      }

      dap.listeners.before["event_terminated"]["easy-dotnet"] = function()
        debug_dll = nil
      end

      dap.adapters.coreclr = {
        type = "executable",
        command = "/usr/local/netcoredbg/netcoredbg",
        args = { "--interpreter=vscode" },
      }
    end
  end,
  dependencies = {
    { "nvim-neotest/nvim-nio" },
    {
      "rcarriga/nvim-dap-ui",
      config = function()
        require("dapui").setup()
      end,
    },
  },
}
-- return {
--   "mfussenegger/nvim-dap",
--   enabled = false,
--   dependencies = {
--     "rcarriga/nvim-dap-ui",
--     "nvim-neotest/nvim-nio",
--   },
--   config = function()
--     local dap = require("dap")
--     local dapui = require("dapui")
--
--     dapui.setup({
--       icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
--       mappings = {
--         -- Use a table to apply multiple mappings
--         expand = { "<CR>", "<2-LeftMouse>" },
--         open = "o",
--         remove = "d",
--         edit = "e",
--         repl = "r",
--         toggle = "t",
--       },
--       -- Use this to override mappings for specific elements
--       element_mappings = {
--         -- Example:
--         -- stacks = {
--         --   open = "<CR>",
--         --   expand = "o",
--         -- }
--       },
--       -- Expand lines larger than the window
--       -- Requires >= 0.7
--       expand_lines = vim.fn.has("nvim-0.7") == 1,
--       -- Layouts define sections of the screen to place windows.
--       -- The position can be "left", "right", "top" or "bottom".
--       -- The size specifies the height/width depending on position. It can be an Int
--       -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
--       -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
--       -- Elements are the elements shown in the layout (in order).
--       -- Layouts are opened in order so that earlier layouts take priority in window sizing.
--       layouts = {
--         {
--           elements = {
--             -- Elements can be strings or table with id and size keys.
--             { id = "scopes", size = 0.25 },
--             "breakpoints",
--             "stacks",
--             "watches",
--           },
--           size = 40, -- 40 columns
--           position = "left",
--         },
--         {
--           elements = {
--             "repl",
--             "console",
--           },
--           size = 0.25, -- 25% of total lines
--           position = "bottom",
--         },
--       },
--       controls = {
--         -- Requires Neovim nightly (or 0.8 when released)
--         enabled = true,
--         -- Display controls in this element
--         element = "repl",
--         icons = {
--           pause = "",
--           play = "",
--           step_into = "",
--           step_over = "",
--           step_out = "",
--           step_back = "",
--           run_last = "↻",
--           terminate = "□",
--         },
--       },
--       floating = {
--         max_height = nil, -- These can be integers or a float between 0 and 1.
--         max_width = nil, -- Floats will be treated as percentage of your screen.
--         border = "single", -- Border style. Can be "single", "double" or "rounded"
--         mappings = {
--           close = { "q", "<Esc>" },
--         },
--       },
--       windows = { indent = 1 },
--       render = {
--         max_type_length = nil, -- Can be integer or nil.
--         max_value_lines = 100, -- Can be integer or nil.
--       },
--     })
--
--     vim.keymap.set("n", "<Leader>dc", dap.continue, {})
--     vim.keymap.set("n", "<Leader>do", dap.step_over, {})
--     vim.keymap.set("n", "<Leader>di", dap.step_into, {})
--     vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
--
--     dap.listeners.before.attach.dapui_config = function()
--       dapui.open()
--     end
--     dap.listeners.before.launch.dapui_config = function()
--       dapui.open()
--     end
--     dap.listeners.before.event_terminated.dapui_config = function()
--       dapui.close()
--     end
--     dap.listeners.before.event_exited.dapui_config = function()
--       dapui.close()
--     end
--
--     -- dotnet
--     dap.adapters.coreclr = {
--       type = "executable",
--       command = "/usr/local/bin/netcoredbg/netcoredbg",
--       args = { "--interpreter=vscode", "--log=debug" },
--     }
--
--     -- dap.configurations.cs = {
--     --   {
--     --     type = "coreclr",
--     --     name = "launch - netcoredbg",
--     --     request = "launch",
--     --     program = function()
--     --       return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
--     --     end,
--     --   },
--     -- }
--     vim.g.dotnet_build_project = function()
--       local default_path = vim.fn.getcwd() .. "/"
--       if vim.g["dotnet_last_proj_path"] ~= nil then
--         default_path = vim.g["dotnet_last_proj_path"]
--       end
--       local path = vim.fn.input("Path to your *proj file", default_path, "file")
--       vim.g["dotnet_last_proj_path"] = path
--       local cmd = "dotnet build -c Debug " .. path .. " > /dev/null"
--       print("")
--       print("Cmd to execute: " .. cmd)
--       local f = os.execute(cmd)
--       if f == 0 then
--         print("\nBuild: ✔️ ")
--       else
--         print("\nBuild: ❌ (code: " .. f .. ")")
--       end
--     end
--
--     vim.g.dotnet_get_dll_path = function()
--       local request = function()
--         return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
--       end
--
--       if vim.g["dotnet_last_dll_path"] == nil then
--         vim.g["dotnet_last_dll_path"] = request()
--       else
--         if
--             vim.fn.confirm(
--               "Do you want to change the path to dll?\n" .. vim.g["dotnet_last_dll_path"],
--               "&yes\n&no",
--               2
--             ) == 1
--         then
--           vim.g["dotnet_last_dll_path"] = request()
--         end
--       end
--
--       return vim.g["dotnet_last_dll_path"]
--     end
--
--     local config = {
--       {
--         type = "coreclr",
--         name = "launch - netcoredbg",
--         request = "launch",
--         program = function()
--           if vim.fn.confirm("Should I recompile first?", "&yes\n&no", 2) == 1 then
--             vim.g.dotnet_build_project()
--           end
--           return vim.g.dotnet_get_dll_path()
--         end,
--       },
--     }
--
--     dap.configurations.cs = config
--   end,
-- }
