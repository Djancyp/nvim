local M = {}

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end
function M.config()
    dap.adapters.node2 = {
        type = 'executable',
        command = '/usr/bin/node',
        args = { os.getenv('HOME') .. '/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
    }
    dap.adapters.chrome = {
        -- executable: launch the remote debug adapter - server: connect to an already running debug adapter
        type = "executable",
        -- command to launch the debug adapter - used only on executable type
        command = "node",
        args = { os.getenv("HOME") .. "/.local/share/nvim/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js" }
    }
    dap.adapters.firefox = {
        type = 'executable',
        command = 'node',
        args = { os.getenv('HOME') .. "/.local/share/nvim/mason/packages/firefox-debug-adapter/dist/adapter.bundle.js" },
    }
    dap.configurations.typescript = {

        {
            name = "ts-node (Node2 with ts-node)",
            type = "node2",
            request = "launch",
            cwd = vim.loop.cwd(),
            runtimeArgs = { "-r", "/usr/local/lib/node_modules/ts-node/register" },
            runtimeExecutable = "node",
            args = { "--inspect", "${file}" },
            sourceMaps = true,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
        },
        {
            name = "Jest (Node2 with ts-node)",
            type = "node2",
            request = "launch",
            cwd = vim.loop.cwd(),
            runtimeArgs = { "--inspect-brk", "${workspaceFolder}/node_modules/.bin/jest" },
            runtimeExecutable = "node",
            args = { "${file}", "--runInBand", "--coverage", "false" },
            sourceMaps = true,
            port = 9229,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
        },
    }
    dap.configurations.typescriptreact = { -- change to typescript if needed

        {
            name = "Chrome Browser",
            type = "chrome",
            request = "attach",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            -- port = 3000,
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}"
        },
        {
            name = "Attach to url with files served from ./out",
            type = "chrome",
            request = "attach",
            port = 9222,
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}"
        }
        -- {
        --     name = 'Debug with Firefox',
        --     type = 'firefox',
        --     request = 'launch',
        --     reAttach = true,
        --     url = 'http://localhost:3000',
        --     webRoot = '${workspaceFolder}',
        --     firefoxExecutable = '/usr/bin/firefox'
        -- }
    }
    dap.configurations.javascriptreact = { -- change this to javascript if needed
        {
            type = "chrome",
            request = "attach",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            port = 9222,
            webRoot = "${workspaceFolder}"
        }
    }
    dap.configurations.javascript = {
        {
            name = 'Launch',
            type = 'node2',
            request = 'launch',
            program = '${file}',
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = 'inspector',
            console = 'integratedTerminal',
            skipFiles = { "<node_internals>/**", "node_modules/**" },
        },
        {
            -- For this to work you need to make sure the node process is started with the `--inspect` flag.
            name = 'Attach to process',
            type = 'node2',
            request = 'attach',
            processId = require 'dap.utils'.pick_process,
        },
        {
            name = "Jest (Node2 with ts-node)",
            type = "node2",
            request = "launch",
            cwd = vim.loop.cwd(),
            runtimeArgs = { "--inspect-brk", "${workspaceFolder}/node_modules/.bin/jest" },
            runtimeExecutable = "node",
            args = { "${file}", "--runInBand", "--coverage", "false" },
            sourceMaps = true,
            port = 9229,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
        },
    }
    dap.configurations.rust = {
        adapter = {
            type = "executable",
            command = "lldb-vscode-13",
            name = "rt_lldb",
        },
    }
    -- require('dap').set_log_level('INFO')
    dap.defaults.fallback.terminal_win_cmd = '20split new'
    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'Error', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointRejected', { text = 'ﰸ', texthl = 'Error', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DiagnosticSignInfo', linehl = '', numhl = '' })
    -- nvim-telescope/telescope-dap.nvim
end

function M.attach()
    dap.run({
        type = 'node2',
        request = 'attach',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        skipFiles = { '<node_internals>/**/*.js' },
    })
end

function M.attachToRemote()
    dap.run({
        type = 'node2',
        request = 'attach',
        address = "127.0.0.1",
        port = 9229,
        localRoot = vim.fn.getcwd(),
        remoteRoot = "/home/vcap/app",
        sourceMaps = true,
        protocol = 'inspector',
        skipFiles = { '<node_internals>/**/*.js' },
    })
end

return M
