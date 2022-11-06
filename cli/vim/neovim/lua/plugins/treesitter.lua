local treesitter_ok, treesitter = pcall(require, "nvim-treesitter/configs")
if not treesitter_ok then
    return
end

treesitter.setup({
    ensure_installed = "all",
    sync_install = false,
    ignore_install = { "" },
    highlight = {
        enable = true,
        disable = { "" },
        additional_vim_regex_highlighting = true,
    },
    indent = {
        enable = true,
        disable = { "yaml" },
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        },
    }
})

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.cmd "set nofoldenable"


local ts_utils = require("nvim-treesitter.ts_utils")
local M = {}
local api = vim.api

local get_parent = function(node)
    local prev = assert(ts_utils.get_previous_node(node, true, true))
    while (prev:parent() == node:parent()) do
        node = prev
        if (ts_utils.get_previous_node(prev, true, true) == nil) then
            -- If we're at the last node...
            return node
        end
        prev = ts_utils.get_previous_node(prev, true, true)
    end
    return node
end

local get_master_node = function()
    local node = ts_utils.get_node_at_cursor()
    if node == nil then
        error("No Treesitter parser found.")
    end

    local start_row = node:start()
    local parent = node:parent()

    while (parent ~= nil and parent:start() == start_row) do
        node = parent
        parent = node:parent()
    end

    return node
end

M.parent = function()
    local node = get_master_node()
    local parent = get_parent(node)
    ts_utils.goto_node(parent)
end

-- function to create a list of commands and convert them to autocommands
-------- This function is taken from https://github.com/norcalli/nvim_utils
function M.nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        api.nvim_command('augroup ' .. group_name)
        api.nvim_command('autocmd!')
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten { 'autocmd', def }, ' ')
            api.nvim_command(command)
        end
        api.nvim_command('augroup END')
    end
end

M.nvim_create_augroups({
    open_folds = {
        -- { "BufReadPost,FileReadPost,VimEnter", "*", "normal zR" },
        -- { "BufEnter,FileReadPost,VimEnter", "*", "TSBufEnable highlight" },
    }
})


api.nvim_create_user_command("GotoParent", M.parent, {})

return M
