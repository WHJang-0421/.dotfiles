-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		"tpope/vim-fugitive",
		{      -- useful plugin to show you pending keybinds.
			"folke/which-key.nvim",
			event = "vimenter", -- sets the loading event to 'vimenter'
			opts = {
				-- delay between pressing a key and opening which-key (milliseconds)
				-- this setting is independent of vim.o.timeoutlen
				delay = 0,
				icons = {
					-- set icon mappings to true if you have a nerd font
					mappings = vim.g.have_nerd_font,
					-- if you are using a nerd font: set icons.keys to an empty table which will use the
					-- default which-key.nvim defined nerd font icons, otherwise define a string table
					keys = {},
				},

				-- document existing key chains
				spec = {
					{ "<leader>f", group = "[f]ind" },
					{ "<leader>g", group = "[g]oto" },
					{ "<leader>x", group = "e[x]ecute" },
				},
			},
		},
		{
			"nvim-treesitter/nvim-treesitter",
			branch = "master",
			lazy = false,
			build = ":tsupdate",
			main = "nvim-treesitter.configs", -- sets main module to use for opts
			-- [[ configure treesitter ]] see `:help nvim-treesitter`
			opts = {
				ensure_installed = {
					"bash",
					"c",
					"diff",
					"html",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"query",
					"vim",
					"vimdoc",
					"json",
				},
				-- autoinstall languages that are not installed
				auto_install = true,
				highlight = {
					enable = true,
					-- some languages depend on vim's regex highlighting system (such as ruby) for indent rules.
					--  if you are experiencing weird indenting issues, add the language to
					--  the list of additional_vim_regex_highlighting and disabled languages for indent.
					additional_vim_regex_highlighting = { "ruby" },
				},
				indent = { enable = true, disable = { "ruby" } },
			},
		},
		{
			"mbbill/undotree",
			config = function()
				vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
			end
		},
		{
			"nvim-telescope/telescope.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			config = function()
				require("telescope").setup({
					defaults = {
						vimgrep_arguments = {
							"rg",
							"--color=never",
							"--no-heading",
							"--with-filename",
							"--line-number",
							"--column",
							"--smart-case",
							"--hidden", -- this is the only non-default part
						},
					},
				})
				-- telescope settings & key bindings
				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "<leader>fr", function()
					builtin.find_files({ hidden = true, cwd = "/" })
				end, { desc = "telescope find files from root" })
				vim.keymap.set("n", "<leader>ff", function()
					builtin.find_files({ hidden = true })
				end, { desc = "telescope find files" })
				vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "telescope live grep" })
				vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "telescope buffers" })
				vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "telescope help tags" })
			end,
		},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -s. -bbuild -dcmake_build_type=release && cmake --build build --config release",
		},
		{
			"theprimeagen/harpoon",
			branch = "harpoon2",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				-- harpoon setup (required)
				local harpoon = require("harpoon")
				harpoon:setup()

				vim.keymap.set("n", "<leader>a", function()
					harpoon:list():add()
				end, { desc = "add file to harpoon" })
				vim.keymap.set("n", "<c-e>", function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end)

				vim.keymap.set("n", "<M-1>", function()
					harpoon:list():select(1)
				end)
				vim.keymap.set("n", "<M-2>", function()
					harpoon:list():select(2)
				end)
				vim.keymap.set("n", "<M-3>", function()
					harpoon:list():select(3)
				end)
				vim.keymap.set("n", "<M-4>", function()
					harpoon:list():select(4)
				end)
			end,
		},
		{ -- collection of various small independent plugins/modules
			"echasnovski/mini.nvim",
			config = function()
				-- better around/inside textobjects
				--
				-- examples:
				--  - va)  - [v]isually select [a]round [)]paren
				--  - yinq - [y]ank [i]nside [n]ext [q]uote
				--  - ci'  - [c]hange [i]nside [']quote
				require("mini.ai").setup({ n_lines = 500 })

				-- add/delete/replace surroundings (brackets, quotes, etc.)
				--
				-- - saiw) - [s]urround [a]dd [i]nner [w]ord [)]paren
				-- - sd'   - [s]urround [d]elete [']quotes
				-- - sr)'  - [s]urround [r]eplace [)] [']
				require("mini.surround").setup()

				-- simple and easy statusline.
				--  you could remove this setup call if you don't like it,
				--  and try some other statusline plugin
				local statusline = require("mini.statusline")
				-- set use_icons to true if you have a nerd font
				statusline.setup({ use_icons = vim.g.have_nerd_font })

				-- you can configure sections in the statusline by overriding their
				-- default behavior. for example, here we set the section for
				-- cursor location to line:column
				---@diagnostic disable-next-line: duplicate-set-field
				statusline.section_location = function()
					return "%2l:%-2v"
				end

				-- ... and there is more!
				--  check out: https://github.com/echasnovski/mini.nvim
			end,
		},
		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
			config = function()
				vim.cmd.colorscheme "catppuccin"
			end
		},
		{
			"mason-org/mason.nvim",
			opts = {}
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"saghen/blink.cmp",
				{
					"folke/lazydev.nvim",
					ft = "lua", -- only load on lua files
					opts = {
						library = {
							-- See the configuration section for more details
							-- Load luvit types when the `vim.uv` word is found
							{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
						},
					},
				},
			},
			config = function()
				local capabilities = require('blink.cmp').get_lsp_capabilities()
				require("lspconfig").lua_ls.setup { capabilities = capabilities }
				require("lspconfig").pyright.setup { capabilities = capabilities }
			end
		},
		{
			'stevearc/conform.nvim',
			keys = {
				{
					'<leader>fc',
					function()
						require('conform').format { async = true, lsp_format = 'fallback' }
					end,
					mode = '',
					desc = '[F]ormat [C]urrent buffer',
				}
			},
			opts = {
				formatters_by_ft = { python = { "black" }, },
			},
		},
		{
			'saghen/blink.cmp',
			dependencies = { 'rafamadriz/friendly-snippets' },

			version = '1.*',
			opts = {
				keymap = { preset = 'default' },

				appearance = {
					nerd_font_variant = 'mono'
				},

				-- Default list of enabled providers
				sources = {
					default = { 'lsp', 'path', 'snippets', 'buffer' },
				},
			},
			opts_extend = { "sources.default" }
		},
		{
			'MeanderingProgrammer/render-markdown.nvim',
			dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
			opts = {},
		}
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
