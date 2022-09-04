local M = {}

function M.config()
    local present, notify = pcall(require, "notify")
    if present then
        notify.setup({
            background_colour = "#000000",
            stages = "fade",
        })
        vim.notify = notify
    end
end

return M
