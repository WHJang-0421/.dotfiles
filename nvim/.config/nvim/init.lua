-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.have_nerd_font = true

vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.breakindent = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.inccommand = "split"
vim.o.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.confirm = true

-- key mappings
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>", { desc = "[P]roject [V]iew (open netrw)" })

-- custom commands
vim.api.nvim_create_user_command("SudoW", function()
	vim.cmd("silent! w !pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY tee % >/dev/null") -- Save file using pkexec
	vim.cmd("edit!") -- Force reload the file
end, {})

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "undotree", "man", "netrw" },
	desc = "Adjust options (like relative line number display) when entering special windows",
	group = vim.api.nvim_create_augroup("netrw-setup", { clear = true }),
	callback = function()
		vim.opt.relativenumber = true
	end,
})

vim.diagnostic.config({
	virtual_lines = true,
})

-- now starts the whole plugin business
require("config.lazy")
