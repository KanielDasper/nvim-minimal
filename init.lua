vim.g.mapleader = " "
vim.opt.signcolumn = "yes:1"
vim.opt.cursorlineopt = "number"
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menu,menuone,noinsert"
vim.opt.statusline:prepend("(%n) ")
vim.opt.fillchars = { diff = "╱" }
vim.opt.pumheight = 10
vim.opt.shiftwidth = 2
vim.opt.laststatus = 2
vim.opt.tabstop = 2
vim.opt.number = true
vim.opt.autoread = true
vim.opt.undofile = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.relativenumber = true

vim.pack.add({
    { src = "https://github.com/nvim-mini/mini.nvim", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/folke/tokyonight.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/tpope/vim-surround" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/vimwiki/vimwiki" }, -- Substitute with dir shortcut and 'gf'
})
vim.g.vimwiki_list = { { path = "~/Documents/vimwiki", syntax = "markdown", ext = ".md" } }
vim.g.vimwiki_global_ext = 0

local choose_all = function()
    local mappings = require("mini.pick").get_picker_opts().mappings
    vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
end

require("mini.pairs").setup()
require("mini.diff").setup()
require("mini.ai").setup()
require("mini.icons").setup()
require("oil").setup({ view_options = { show_hidden = true } })
require("tokyonight").setup({ opts = { transparent = true } })
require("mini.pick").setup({
    mappings = { choose_all = { char = "<C-q>", func = choose_all } },
})
require("nvim-treesitter.configs").setup({
    ensure_installed = { "python", "bash", "json" },
    highlight = { enable = true },
})
require("conform").setup({
    formatters = {
        ["*"] = { async = true },
    },
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        json = { "jq" },
        markdown = { "prettier" },
    },
})

vim.cmd([[colorscheme tokyonight-moon]])
require("mini.misc").setup_termbg_sync()

local opts = { noremap = true, silent = true }
vim.keymap.set({ "n", "v" }, "æ", ":")
vim.keymap.set("n", "qæ", "q:", opts)
vim.keymap.set("n", "U", "<C-R>", opts)
vim.keymap.set("n", "<C-n>", "<cmd>bnext<cr>", opts)
vim.keymap.set("n", "<C-p>", "<cmd>bprevious<cr>", opts)
vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", opts)
vim.keymap.set("n", "<leader>g", "<cmd>Git<cr>", opts)
vim.keymap.set("n", "<leader>f", "<cmd>Pick files<cr>", opts)
vim.keymap.set("n", "<leader>r", "<cmd>Pick grep_live<cr>", opts)
vim.keymap.set("n", "<leader>js", require("conform").format, opts)
vim.keymap.set("n", "<leader>?", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "grd", vim.diagnostic.setqflist, opts)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "<leader>q", require("mini.bufremove").delete)
vim.keymap.set("n", "go", require("mini.diff").toggle_overlay)
vim.keymap.set("n", "<Backspace>", ":nohl<cr>", opts)
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", opts)
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", opts)
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)
vim.keymap.set("t", "<Esc>", "<c-\\><c-n>", opts)
vim.keymap.set("i", "<CR>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-e><CR>"
    else
        return "<CR>"
    end
end, { expr = true })

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_comp", {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method("textDocument/completion") then
            local chars = {}
            for i = 32, 126 do
                table.insert(chars, string.char(i))
            end
            client.server_capabilities.completionProvider.triggerCharacters = chars
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        (vim.hl or vim.highlight).on_yank()
    end,
})
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.lsp.enable({ "lua_ls", "basedpyright", "ruff", "jsonls" })
