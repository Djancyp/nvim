local packer_status_ok, packer = pcall(require, "packer")
if packer_status_ok then
	local plugins = {
		{
			"lewis6991/impatient.nvim",
			config = function()
				require("impatient")
				vim.g.impatient_show_count = 1
				vim.g.impatient_show_count_format = " %d "
			end,
		},
		{
			"wbthomason/packer.nvim",
		},
		-- Lua functions
		{ "nvim-lua/plenary.nvim" },

		-- Popup API
		{ "nvim-lua/popup.nvim" },
		-- Custom Plugins
		-- {
		-- 	"folke/lua-dev.nvim",
		-- 	config = function() end,
		-- },
		-- { "RRethy/vim-illuminate" },
		{
			"Djancyp/custom-theme.nvim",
			after = "nvim-treesitter",
			config = function()
				require("custom-theme").setup()
				local hl = vim.api.nvim_set_hl
				hl(0, "CursorLineNr", { bold = true, fg = "#D7BA7D", bg = "#1E1E1E", italic = true })
			end,
		},
		{
			"catppuccin/nvim",
			as = "catppuccin",
			config = function()
				vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha

				require("catppuccin").setup()

				vim.cmd([[colorscheme catppuccin]])
			end,
		},
		-- End of custom plugins
		-- Start screen
		{
			"goolord/alpha-nvim",
			config = function()
				require("configs.dashboard").config()
			end,
		},
		-- winbar with symbol
		{
			"Djancyp/symbol-winbar",
			config = function()
				require("symbols-winbar").setup({
					lsp = false,
					gps = true,
				})
			end,
		},
		{
			"kyazdani42/nvim-web-devicons",
			config = function()
				require("nvim-web-devicons").setup({
					-- your personal icons can go here (to override)
					-- you can specify color or cterm_color instead of specifying both of them
					-- DevIcon will be appended to `name`
					override = {
						zsh = {
							icon = "",
							color = "#428850",
							cterm_color = "65",
							name = "Zsh",
						},
					},
					-- globally enable default icons (default to false)
					-- will get overridden by `get_icons` option
					default = true,
				})
			end,
		},
		-- Status line
		{
			"feline-nvim/feline.nvim",
			after = "nvim-web-devicons",
			config = function()
				require("configs.feline")
			end,
		},
		-- {
		-- 	"nvim-lualine/lualine.nvim",
		-- 	config = function()
		-- 		require("configs.lualine")
		-- 	end,
		-- },
		-- File explorer
		{
			"nvim-neo-tree/neo-tree.nvim",
			cmd = "Neotree",
			branch = "v2.x",
			requires = {
				"nvim-lua/plenary.nvim",
				"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
			},
			config = function()
				require("configs.neo-tree").config()
			end,
		},
		-- Telescope
		{
			"nvim-telescope/telescope.nvim",
			cmd = "Telescope",
			module = "telescope",
			config = function()
				require("configs.telescope").config()
			end,
		},
		{
			("nvim-telescope/telescope-%s-native.nvim"):format(vim.fn.has("win32") == 1 and "fzy" or "fzf"),
			after = "telescope.nvim",
			run = "make",
			config = function()
				require("telescope").load_extension(vim.fn.has("win32") == 1 and "fzy_native" or "fzf")
			end,
		},
		-- Lsp Settings
		{
			"williamboman/mason.nvim",
			config = function()
				require("configs.lsp")
			end,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			config = function() end,
		},
		{
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				require("configs.lsp.null-ls")
			end,
		},
		{
			"jayp0521/mason-null-ls.nvim",
			config = function()
				local mason_null_ls = require("mason-null-ls")
				mason_null_ls.setup({
					-- list of formatters & linters for mason to install
					ensure_installed = {
						"prettier", -- ts/js formatter
						"stylua", -- lua formatter
						"eslint_d", -- ts/js linter
					},
					-- auto-install configured formatters & linters (with null-ls)
					automatic_installation = true,
				})
			end,
		}, -- bridges gap b/w mason & null-ls
		{
			"neovim/nvim-lspconfig",
			module = "lspconfig",
			opt = true,
			setup = function() end,
		},
		{ "jose-elias-alvarez/typescript.nvim" },
		{ "onsails/lspkind.nvim" }, -- vs-code like icons for autocompletion
		-- Syntax highlighting
		{
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = function()
				require("configs.treesitter").config()
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			config = function()
				require("treesitter-context").setup()
			end,
		},

		{ "p00f/nvim-ts-rainbow" },
		-- Completion engine
		-- {
		--     "github/copilot.vim",
		-- },
		{
			"zbirenbaum/copilot.lua",
			event = { "VimEnter" },
			config = function()
				vim.defer_fn(function()
					require("copilot").setup()
				end, 100)
			end,
		},
		{
			"zbirenbaum/copilot-cmp",
			after = { "copilot.lua" },
			config = function()
				require("copilot_cmp").setup()
			end,
		},
		{
			"hrsh7th/nvim-cmp",
			after = { "copilot.lua" },
			config = function()
				require("configs.cmp").config()
			end,
		},
		{
			"saadparwaiz1/cmp_luasnip",
			after = "nvim-cmp",
		},
		-- Buffer completion source
		{
			"hrsh7th/cmp-buffer",
			after = "nvim-cmp",
			config = function()
				require("core.utils").add_user_cmp_source("buffer")
			end,
		},

		-- Path completion source
		{
			"hrsh7th/cmp-path",
			after = "nvim-cmp",
			config = function()
				require("core.utils").add_user_cmp_source("path")
			end,
		},
		{
			"hrsh7th/cmp-nvim-lsp",
			config = function() end,
		},
		-- snippets
		{
			"rafamadriz/friendly-snippets",
			after = "nvim-cmp",
		},
		{
			"L3MON4D3/LuaSnip",
			after = "friendly-snippets",
			config = function()
				require("configs.luasnip").config()
				require("luasnip.loaders.from_vscode").lazy_load()
				require("luasnip.loaders.from_snipmate").lazy_load({ paths = "~/.config/nvim/snippets" })
			end,
		},
		-- Utils
		-- Smarter Splits
		-- {
		-- 	"mrjones2014/smart-splits.nvim",
		-- 	module = "smart-splits",
		-- 	config = function()
		-- 		require("configs.smart-splits").config()
		-- 	end,
		-- },
		-- Comments
		{
			"numToStr/Comment.nvim",
			config = function()
				require("configs.comments").config()
			end,
		},
		-- Context based commenting
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			after = "nvim-treesitter",
		},
		{
			"Djancyp/better-comments.nvim",
			config = function()
				require("better-comment").Setup({})
			end,
		},
		-- Terminal
		{
			"akinsho/nvim-toggleterm.lua",
			cmd = "ToggleTerm",
			module = { "toggleterm", "toggleterm.terminal" },
			config = function()
				require("configs.toggleterm").config()
			end,
		},
		-- Git integration
		{
			"lewis6991/gitsigns.nvim",
			opt = true,
			setup = function()
				require("core.utils").defer_plugin("gitsigns.nvim")
			end,
			config = function()
				require("configs.gitsigns").config()
			end,
		}, -- Notification Enhancer
		{ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" },
		{
			"rcarriga/nvim-notify",
			config = function()
				require("configs.notify").config()
			end,
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				vim.opt.termguicolors = true
				vim.opt.list = true

				require("indent_blankline").setup({
					buftype_exclude = {
						"nofile",
						"terminal",
						"lsp-installer",
						"lspinfo",
					},
					filetype_exclude = {
						"help",
						"startify",
						"aerial",
						"alpha",
						"dashboard",
						"packer",
						"neogitstatus",
						"NvimTree",
						"neo-tree",
						"Trouble",
					},
					context_patterns = {
						"class",
						"return",
						"function",
						"method",
						"^if",
						"^while",
						"jsx_element",
						"^for",
						"^object",
						"^table",
						"block",
						"arguments",
						"if_statement",
						"else_clause",
						"jsx_element",
						"jsx_self_closing_element",
						"try_statement",
						"catch_clause",
						"import_statement",
						"operation_type",
					},
					show_trailing_blankline_indent = false,
					use_treesitter = true,
					char = "▏",
					context_char = "▏",
					show_current_context = true,
				})
			end,
		},
		-- Color highlighting
		{
			"norcalli/nvim-colorizer.lua",
			event = { "BufRead", "BufNewFile" },
			config = function()
				require("configs.colorizer").config()
			end,
		},
		{
			"olexsmir/gopher.nvim",
			config = function()
				require("gopher").setup({
					commands = {
						go = "go",
						gomodifytags = "gomodifytags",
						gotests = "~/go/bin/gotests", -- also you can set custom command path
						impl = "impl",
						iferr = "iferr",
					},
				})
			end,
		},
		-- Debugeer
		{
			"mfussenegger/nvim-dap",
			config = function()
				require("configs.dap").config()
			end,
		},
		{
			"leoluz/nvim-dap-go",
			config = function()
				require("dap-go").setup()
			end,
		},
		{
			"rcarriga/nvim-dap-ui",
			config = function()
				require("dapui").setup({
					expand_lines = true,
					icons = { expanded = "", collapsed = "", circular = "" },
					mappings = {
						-- Use a table to apply multiple mappings
						expand = { "<CR>", "<2-LeftMouse>" },
						open = "o",
						remove = "d",
						edit = "e",
						repl = "r",
						toggle = "t",
					},
					layouts = {
						{
							elements = {
								{ id = "scopes", size = 0.33 },
								{ id = "breakpoints", size = 0.17 },
								{ id = "stacks", size = 0.25 },
								{ id = "watches", size = 0.25 },
							},
							size = 0.33,
							position = "right",
						},
						{
							elements = {
								{ id = "repl", size = 0.45 },
								{ id = "console", size = 0.55 },
							},
							size = 0.27,
							position = "bottom",
						},
					},
					floating = {
						max_height = 0.9,
						max_width = 0.5, -- Floats will be treated as percentage of your screen.
						border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
						mappings = {
							close = { "q", "<Esc>" },
						},
					},
				})
			end,
		},
		-- HTML Emmet
		{ "mattn/emmet-vim" },
		{
			"windwp/nvim-ts-autotag",
			after = "nvim-treesitter",
			config = function()
				require("nvim-ts-autotag").setup()
			end,
		},
		-- autopairs
		{
			"windwp/nvim-autopairs",
			config = function()
				require("nvim-autopairs").setup({
					fast_wrap = {
						map = "<M-e>",
						chars = { "{", "[", "(", '"', "'" },
						pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
						end_key = "$",
						keys = "qwertyuiopzxcvbnmasdfghjkl",
						check_comma = true,
						highlight = "Search",
						highlight_grey = "Comment",
					},
					disable_filetype = { "TelescopePrompt", "vim" },
				})
			end,
		},
		{
			"declancm/cinnamon.nvim",
			config = function()
				require("cinnamon").setup()
			end,
		},
		{ "ThePrimeagen/harpoon" },
		-- Post get rest managment
		{
			"NTBBloodbath/rest.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("configs.rest").setup()
			end,
		},
		-- Note
		{ "vimwiki/vimwiki" },
		{ "nvim-treesitter/playground" },
		-- Rust
		{ "simrat39/rust-tools.nvim" },
		{
			"j-hui/fidget.nvim",
			config = function()
				require("fidget").setup()
			end,
		},
	}
	packer.startup({
		function(use)
			for _, plugin in pairs(plugins) do
				use(plugin)
			end
		end,
		auto_clean = true,
		compile_on_sync = true,
	})
end
