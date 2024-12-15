return {
  {
    "mfussenegger/nvim-dap",
    lazy = true, -- never debugging right when opening, so save the startup time
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "mxsdev/nvim-dap-vscode-js",
      -- Lazy spec that builds the latest 1.x vscode js debugger from source
      {
        "microsoft/vscode-js-debug",
        version = "1.x",
        build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
      },
    },
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Continue",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: step over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: step into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: step out",
      },
      {
        "<leader>dt",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Debug: Toggle breakpoint",
      },
      {
        "<leader>dq",
        function()
          require("dap").disconnect()
          require("dap").close()
        end,
        desc = "Debug: quit debug session",
      },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      require("dap-vscode-js").setup({
        -- append the nvim data path with the path to the root directory of the debugger
        -- `nvim-dap-vscode-js` has the rest of the path from there hard coded
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = {
          "pwa-node",
          "pwa-chrome",
          "pwa-msedge",
          "node-terminal",
          "pwa-extensionHost",
        },
      })

      dapui.setup()
      -- js/node debugger config. NOT CURRENTLY WORKING
      for _, language in ipairs({ "javascript", "typescript", "svelte" }) do
        dap.configurations[language] = {
          {
            -- name the action for when selecting this config
            name = "Launch current file in new node debugger",
            -- use nvim-dap-vscode-js pwa-node debug adapter
            type = "pwa-node",
            -- Launch a new process to attach the debugger to
            request = "launch",
            program = "${file}",
          },
          {
            name = "Attach debugger to existing `node --inspect` process",
            -- use nvim-dap-vscode-js's pwa-node debug adapter
            type = "pwa-node",
            -- attach to an already running node process with --inspect flag
            -- default port: 9222
            request = "attach",
            -- allows us to pick the process using a picker
            processId = require("dap.utils").pick_process,
            -- for compiled languages like TypeScript or Svelte.js
            sourceMaps = true,
            -- resolve source maps in nested locations while ignoring node_modules
            resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
            -- path to src in vite based projects (and most other projects as well)
            cwd = "${workspaceFolder}/src",
            -- we don't want to debug code inside node_modules, so skip it!
            skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
          },
          {
            -- name of the debug action
            name = "Launch Arc to debug client side code",
            -- use nvim-dap-vscode-js's pwa-chrome debug adapter
            type = "pwa-chrome",
            request = "launch",
            runtimeExecutable = "/Applications/Arc.app/Contents/MacOS/Arc",
            -- default vite dev server url
            url = "http://localhost:5173",
            -- for TypeScript/Svelte
            sourceMaps = true,
            webRoot = "${workspaceFolder}/src",
            protocol = "inspector",
            port = 9222,
            -- skip files from vite's hmr
            skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
          },
          {
            name = "Debug jest test",
            type = "pwa-node",
            request = "attach",
            port = 9229,
          },
          --[[ another thing to try:
            {
              name = "Debug Jest Tests",
              type = "node2",
              request = "launch",
              runtimeArgs = {
                "--inspect-brk",
                "${workspaceFolder}/node_modules/.bin/jest",
                "--runInBand"
              },
              console = "integratedTerminal",
              internalConsoleOptions = "neverOpen",
              cwd = "${workspaceFolder}",
            }
          --]]
        }
      end
      -- Automatically open and close the debugger
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.after.event_initialized.dapui_config = function()
        dapui.open({ reset = true })
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- make breakpoints look like breakpoints
      vim.fn.sign_define("DapBreakpoint", {
        text = "🔴", -- You can use any icon you prefer
        texthl = "DapBreakpointSymbol",
        linehl = "",
        numhl = "",
      })
    end,
  },
}
