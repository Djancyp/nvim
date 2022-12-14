local M = {}

function M.config()
    local present, alpha = pcall(require, "alpha")
    if present then
        local dashboard = require 'alpha.themes.startify'
        local leader = "SPC"
        dashboard.section.header.opts = {
            position = "left",
            hl = "Type",
            -- wrap = "overflow";
        }
        dashboard.section.header.val = {
            [[                               __                ]],
            [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
            [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
            [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
            [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
            [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
            [[]],
            "Hello, " .. vim.fn.expand("$USER") .. "!",
            "Today is " .. os.date("%A, %B %d, %Y"),
            "Plugins: " .. vim.fn.len(vim.fn.globpath("~/.local/share/nvim/site/pack/packer/start", "*", 0, 1)),
        }
        dashboard.button = function(sc, txt, keybind, keybind_opts)
            local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

            local opts = {
                position = "right",
                shortcut = "[" .. sc .. "] ",
                cursor = 1,
                -- width = 50,
                align_shortcut = "left",
                hl_shortcut = { { "Operator", 0, 1 }, { "Number", 1, #sc + 1 }, { "Operator", #sc + 1, #sc + 2 } },
                shrink_margin = false,
            }
            if keybind then
                keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
                opts.keymap = { "n", sc_, keybind, { noremap = false, silent = true, nowait = true } }
            end

            local function on_press()
                local key = vim.api.nvim_replace_termcodes(sc_ .. "<Ignore>", true, false, true)
                vim.api.nvim_feedkeys(key, "t", false)
            end

            return {
                type = "button",
                val = txt,
                on_press = on_press,
                opts = opts,
            }
        end
        alpha.setup(dashboard.config)
    end
end

return M
