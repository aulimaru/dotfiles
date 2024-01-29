return {
	"hrsh7th/nvim-cmp",
	version = false, -- last release is way too old
	-- event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-vsnip",
		"onsails/lspkind-nvim",
		"rafamadriz/friendly-snippets",
	},
	config = function()
		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
		local cmp = require("cmp")
		local lspkind = require("lspkind")
		cmp.setup({
			snippet = {
				expand = function(args)
					-- For `vsnip` users.
					vim.fn["vsnip#anonymous"](args.body)

					-- For `luasnip` users.
					-- require('luasnip').lsp_expand(args.body)

					-- For `ultisnips` users.
					-- vim.fn["UltiSnips#Anon"](args.body)

					-- For `snippy` users.
					-- require'snippy'.expand_snippet(args.body)
				end,
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				-- For vsnip users.
				{ name = "vsnip" },
				-- For luasnip users.
				-- { name = 'luasnip' },
				--For ultisnips users.
				-- { name = 'ultisnips' },
				-- -- For snippy users.
				-- { name = 'snippy' },
			}, { { name = "buffer" }, { name = "path" } }),
			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				["<S-CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				["<C-CR>"] = function(fallback)
					cmp.abort()
					fallback()
				end,
			}),
			-- formatting = {
			--     format = lspkind.cmp_format({
			--         with_text = true, -- do not show text alongside icons
			--         maxwidth = 50,    -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			--         before = function(entry, vim_item)
			--             -- Source 显示提示来源
			--             vim_item.menu = "[" .. string.upper(entry.source.name) .. "]"
			--             return vim_item
			--         end
			--     })
			-- },
		})
	end,
}
