local M = {}

function M.setup()
	-- require("core.utils").vim_opts({ g = { neo_tree_remove_legacy_commands = true } })
end

function M.config()
	-- local status_ok, neotree = pcall(require, "neo-tree")
	-- if status_ok then
	--     neotree.setup(require("core.utils").user_plugin_opts("plugins.neo-tree", {
	--         popup_border_style = "rounded",
	--         enable_diagnostics = false,
	--         default_component_configs = {
	--             indent = {
	--                 padding = 0,
	--                 with_expanders = false,
	--             },
	--             icon = {
	--                 folder_closed = "",
	--                 folder_open = "",
	--                 folder_empty = "",
	--                 default = "",
	--             },
	--             git_status = {
	--                 symbols = {
	--                     added = "",
	--                     deleted = "",
	--                     modified = "",
	--                     renamed = "➜",
	--                     untracked = "★",
	--                     ignored = "◌",
	--                     unstaged = "✗",
	--                     staged = "✓",
	--                     conflict = "",
	--                 },
	--             },
	--         },
	--         window = {
	--             width = 25,
	--             mappings = {
	--                 ["o"] = "open",
	--             },
	--         },
	--         filesystem = {
	--             filtered_items = {
	--                 visible = false,
	--                 hide_dotfiles = true,
	--                 hide_gitignored = false,
	--                 hide_by_name = {
	--                     ".DS_Store",
	--                     "thumbs.db",
	--                     "node_modules",
	--                     "__pycache__",
	--                 },
	--             },
	--             follow_current_file = true,
	--             hijack_netrw_behavior = "open_current",
	--             use_libuv_file_watcher = true,
	--         },
	--         git_status = {
	--             window = {
	--                 position = "float",
	--             },
	--         },
	--         event_handlers = {
	--             {
	--                 event = "vim_buffer_enter",
	--                 handler = function(_)
	--                     if vim.bo.filetype == "neo-tree" then
	--                         vim.wo.signcolumn = "auto"
	--                     end
	--                 end,
	--             },
	--         },
	--     }))
	-- end
	--
	-- import nvim-tree plugin safely
	local setup, nvimtree = pcall(require, "nvim-tree")
	if not setup then
		return
	end

	-- recommended settings from nvim-tree documentation
	vim.g.loaded = 1
	vim.g.loaded_netrwPlugin = 1

	-- change color for arrows in tree to light blue
	vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

	-- configure nvim-tree
	nvimtree.setup({
		-- change folder arrow icons
		renderer = {
			icons = {
				glyphs = {
					folder = {
						arrow_closed = "", -- arrow when folder is closed
						arrow_open = "", -- arrow when folder is open
					},
				},
			},
		},
		-- disable window_picker for
		-- explorer to work well with
		-- window splits
		actions = {
			open_file = {
				window_picker = {
					enable = false,
				},
			},
		},
		-- 	git = {
		-- 		ignore = false,
		-- 	},
	})
end

return M
