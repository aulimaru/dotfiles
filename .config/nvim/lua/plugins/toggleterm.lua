return {
	"akinsho/toggleterm.nvim",
	event = "VeryLazy",
	version = "*",
	opts = {
		-- size can be a number or function which is passed the current terminal
		size = 15,
		open_mapping = [[<c-\>]],
		hide_numbers = true,
		autochdir = true, -- when neovim changes it current directory the terminal will change it's own when next it's opened
		shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
		shading_factor = "-30", -- the percentage by which to lighten terminal background, default: -30 (gets multiplied by -3 if background is light)
		start_in_insert = true,
		insert_mappings = true, -- whether or not the open mapping applies in insert mode
		terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
		persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
		direction = "horizontal",
		close_on_exit = true, -- close the terminal window when the process exits
		auto_scroll = true, -- automatically scroll to the bottom on terminal output
	},
	-- vim.keymap.set('n', '<leader>t', [[<Cmd>ToggleTerm<CR>]])
	-- vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])
	-- vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]])
	-- vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]])
	-- vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]])
	-- vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]])
	-- vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]])
}
