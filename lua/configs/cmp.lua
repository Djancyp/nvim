local M = {}
function M.config()
	local cmp_status_ok, cmp = pcall(require, "cmp")
	local luasnip = pcall(require, "luasnip")
	local compare = require("cmp.config.compare")
	local status_ok_1, mason_lspconfig = pcall(require, "mason-lspconfig")
	if not status_ok_1 then
		return
	end

	-- import lspkind plugin safely
	local lspkind_status, lspkind = pcall(require, "lspkind")
	if not lspkind_status then
		return
	end
	require("luasnip/loaders/from_vscode").lazy_load()
	vim.opt.completeopt = "menu,menuone,noselect"

	if cmp_status_ok then
		local servers = mason_lspconfig.get_installed_servers()
		cmp.setup({
			preselect = cmp.PreselectMode.None,
			formatting = {
				fields = { "kind", "abbr", "menu" },

				format = lspkind.cmp_format({
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			confirm_opts = {
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			},
			duplicates_default = 0,
			completion = {
				---@usage The minimum length of a word to complete on.
				-- keyword_length = 2,
			},
			experimental = {
				ghost_text = false,
				native_menu = false,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			sources = {
				-- Copilot Source
				{ name = "copilot", group_index = 2 },
				{ name = "nvim_lsp", group_index = 2 },
				{ name = "path", group_index = 2 },
				{ name = "luasnip", group_index = 2 },
				{ name = "buffer", group_index = 2 },
				{ name = "treesitter", group_index = 2 },
			},
			sorting = {
				priority_weight = 2,
				comparators = {
					require("copilot_cmp.comparators").prioritize,
					require("copilot_cmp.comparators").score,
					compare.offset,
					compare.exact,
					-- compare.scopes,
					compare.score,
					compare.recently_used,
					compare.locality,
					-- compare.kind,
					compare.sort_text,
					compare.length,
					compare.order,
				},
			},
			mapping = {
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
				["<C-y>"] = cmp.config.disable,
				["<C-e>"] = cmp.mapping({
					i = cmp.mapping.abort(),
					c = cmp.mapping.close(),
				}),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expandable() then
						luasnip.expand()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, {
					"i",
					"s",
					ialidityState,
				}),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, {
					"i",
					"s",
				}),
			},
		})
	end
end

return M
