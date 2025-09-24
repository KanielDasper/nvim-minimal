vim.g.mapleader = " "
vim.opt.signcolumn = "yes:1"
vim.opt.cursorlineopt = "number"
vim.opt.winborder = "rounded"
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
  -- Disgusting bloat
  { src = "https://github.com/nvim-mini/mini.pick",            version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/folke/tokyonight.nvim.git" },
  { src = "https://github.com/mason-org/mason.nvim" },
  -- Essentials
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/tpope/vim-surround" },
})

require("mini.pick").setup()
require("mason").setup()
require("tokyonight").setup({ opts = { transparent = true } })
require("oil").setup({ view_options = { show_hidden = true } })
require("nvim-treesitter.configs").setup({
  ensure_installed = { "python", "lua", "bash", "markdown", "markdown_inline" },
  highlight = { enable = true }
})

vim.cmd [[colorscheme tokyonight-moon]]
vim.cmd(":hi statusline guibg=NONE")

vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>")
vim.keymap.set("n", "<leader>g", "<cmd>Git<CR>")
vim.keymap.set("n", "<leader>t", "<cmd>terminal<CR>")
vim.keymap.set("n", "<leader>f", "<cmd>Pick files<CR>")
vim.keymap.set("n", "<leader>h", "<cmd>Pick help<CR>")
vim.keymap.set("n", "<leader>.", "<cmd>edit $MYVIMRC<CR>")
vim.keymap.set("n", "<leader>js", vim.lsp.buf.format)
vim.keymap.set("n", "<leader><leader>", "<cmd>Pick buffers<CR>")
vim.keymap.set("n", "<Backspace>", ":nohl<CR>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("t", "<Esc>", "<c-\\><c-n>")
vim.keymap.set("t", "<C-w>q", "<c-\\><c-n><c-w>q")

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
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
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end
})

vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.diagnostic.config({ virtual_text = true })
vim.lsp.enable({ "lua_ls", "basedpyright", "ruff", "denols", "jsonls"})

vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-e><CR>"
  else
    return "<CR>"
  end
end, { expr = true })
