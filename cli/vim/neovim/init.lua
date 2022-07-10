-- global options
vim.g.mapleader = ";"
vim.g.clipboard = {
        name = "sysclip",
        copy = {
                ["+"] = {"xsel", "-b"},
                ["*"] = {"xsel", "-b"},
        },
        paste = {
                ["+"] = {"xsel", "-b"},
                ["*"] = {"xsel", "-b"},
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

-- window options
vim.wo.number = true
vim.wo.relativenumber = true

-- more
require("keybindings")
require("plugins")

gruvbox_ok, gruvbox = pcall(require, "gruvbox")
if gruvbox_ok then
        vim.o.background = "dark"
        vim.cmd [[
        colorscheme gruvbox
        highlight Normal ctermbg=None  guibg=none
        highlight CursorLine ctermbg=240
        ]]
end
