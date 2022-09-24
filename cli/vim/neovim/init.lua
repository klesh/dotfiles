-- global options
vim.g.mapleader = ";"
vim.g.clipboard = {
    name = "sysclip",
    copy = {
        ["+"] = { "xsel", "-b" },
        ["*"] = { "xsel", "-b" },
    },
    paste = {
        ["+"] = { "xsel", "-b" },
        ["*"] = { "xsel", "-b" },
    },
}

-- general options
vim.o.cursorline = true
vim.o.colorcolumn = 120
vim.o.scrolloff = 8
--vim.o.clipboard = "unnamedplus"
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.list = true
vim.o.mouse = "a"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.swapfile = false

-- window options
vim.wo.number = true
vim.wo.relativenumber = true

vim.cmd "set colorcolumn=120"

-- more
require("keybindings")
require("plugins")

local gruvbox_ok, _ = pcall(require, "gruvbox")
if gruvbox_ok then
    vim.o.background = "dark"
    vim.cmd [[
        colorscheme gruvbox
        highlight Normal ctermbg=None  guibg=none
        highlight CursorLine ctermbg=240
        ]]
end


-- format on save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]


-- open quickfix buffer after :grep or :vimgrep
vim.cmd [[
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow
    augroup END
    ]]
