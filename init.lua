vim.g.mapleader = " "
vim.opt.signcolumn = "yes:1"
vim.opt.cursorlineopt = "number"
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menu,menuone,noinsert"
vim.opt.pumheight = 10
vim.opt.fillchars = { diff = "╱" }
vim.opt.number = true
vim.opt.undofile = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.laststatus = 3

vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.nvim",            version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/folke/tokyonight.nvim.git" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/tpope/vim-surround" },
  { src = "https://github.com/vimwiki/vimwiki" }
})
vim.g.vimwiki_list = { { path = "~/Documents/Vimwiki", syntax = "markdown", ext = ".md" } }
vim.g.vimwiki_global_ext = 0

local choose_all = function()
  local mappings = require("mini.pick").get_picker_opts().mappings
  vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
end

require("mason").setup()
require("mini.pairs").setup()
require("mini.diff").setup()
require("oil").setup({ view_options = { show_hidden = true } })
require("tokyonight").setup({ opts = { transparent = true } })
require('mini.pick').setup({
  mappings = { choose_all = { char = '<C-q>', func = choose_all }
  }
})
require("nvim-treesitter.configs").setup({
  ensure_installed = { "python", "lua", "bash", "markdown", "markdown_inline" },
  highlight = { enable = true }
})

vim.cmd [[colorscheme tokyonight-moon]]
vim.cmd [[set statusline+=\ \|%n\|]]
vim.cmd [[ hi statusline guibg=NONE ]]
vim.keymap.set("n", "æ", ":")
vim.keymap.set("n", "U", "<C-R>")
vim.keymap.set("n", "<C-n>", "<cmd>bnext<cr>")
vim.keymap.set("n", "<C-p>", "<cmd>bprevious<cr>")
vim.keymap.set("n", "<leader>t", "q:")
vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>")
vim.keymap.set("n", "<leader>g", "<cmd>Git<cr>")
vim.keymap.set("n", "<leader>f", "<cmd>Pick files<cr>")
vim.keymap.set("n", "<leader>r", "<cmd>Pick grep_live<cr>")
vim.keymap.set("n", "<leader>js", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>q", require("mini.bufremove").delete)
vim.keymap.set("n", "<Backspace>", ":nohl<cr>")
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")
vim.keymap.set("t", "<Esc>", "<c-\\><c-n>")
vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-e><CR>"
  else
    return "<CR>"
  end
end, { expr = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_comp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method('textDocument/completion') then
      local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("hl_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end
})
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.diagnostic.config({ virtual_text = true })
vim.lsp.enable({ "lua_ls", "basedpyright", "ruff", "denols", "jsonls" })
