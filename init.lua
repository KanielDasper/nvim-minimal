vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.laststatus = 3
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menu,menuone,noinsert,noselect"

vim.cmd("hi Normal guibg=NONE ctermbg=NONE")

vim.pack.add({ { src = "https://github.com/mason-org/mason.nvim" }, { src = "https://github.com/nvim-mini/mini.pick", version = "main" }, { src = "https://github.com/stevearc/oil.nvim" }, { src = "https://github.com/tpope/vim-fugitive" } })

require("mini.pick").setup()
require("oil").setup()
require("mason").setup()

vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>")
vim.keymap.set("n", "<leader>f", "<cmd>Pick files<CR>")
vim.keymap.set("n", "<leader>g", "<Cmd>Git<CR>")
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
		if client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = ev.buf,
				callback = function()
					vim.lsp.buf.format()
				end
			})
		end
	end
})


vim.lsp.enable({ "lua_ls" })
