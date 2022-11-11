local status_ok, lspconfig = pcall(require, "lspconfig")
if status_ok then
	local handlers = require("configs.lsp.handlers")
	local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
	local mason_status_ok, mason = pcall(require, "mason")
	local util = require("lspconfig").util
	if not mason_status_ok then
		return
	end

	local status_ok_1, mason_lspconfig = pcall(require, "mason-lspconfig")
	if not status_ok_1 then
		return
	end

	handlers.setup()
	local servers = mason_lspconfig.get_installed_servers()
	local settings = {
		ui = {
			border = "rounded",
			icons = {
				package_installed = "◍",
				package_pending = "◍",
				package_uninstalled = "◍",
			},
		},
		log_level = vim.log.levels.INFO,
		max_concurrent_installers = 4,
	}

	mason.setup(settings)

	mason_lspconfig.setup({
		-- list of servers for mason to install
		ensure_installed = {
			"tsserver",
			"html",
			"cssls",
			"tailwindcss",
			"sumneko_lua",
			"emmet_ls",
			"vuels",
		},
		-- auto-install configured servers (with lspconfig)
		automatic_installation = true, -- not the same as ensure_installed
	})

	local function setup_servers()
		for _, server in ipairs(servers) do
			lspconfig[server].setup({
				capabilities = capabilities,
			})
		end
	end

	setup_servers()

	-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
	-- require 'lspinstall'.post_install_hook = function()
	--     setup_servers() -- reload installed servers
	--     vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
	-- end
	vim.api.nvim_create_autocmd("BufWritePre", {
		callback = function()
			-- check if lsp has a server for buf
			local lsp = vim.lsp.get_active_clients()
			for _, server in ipairs(lsp) do
				if server.server_capabilities.documentFormattingProvider then
					vim.lsp.buf.format()
					return
				end
			end
		end,
	})
end
