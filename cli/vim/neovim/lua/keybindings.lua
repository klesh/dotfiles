local keymap = vim.api.nvim_set_keymap
local NORMAL = 'n'
local INSERT = 'i'
local VISUAL = 'v'
local COMMAND = 'c'


vim.api.nvim_create_user_command("CloseOtherBuffers", function()
    local current_buffer_name = vim.api.nvim_buf_get_name(0)
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if bufname ~= current_buffer_name then
                vim.cmd(":bd " .. bufnr)
            end
        end
    end
end, {})


keymap(NORMAL, '<c-pagedown>', ':bnext<cr>', { noremap = true })
keymap(NORMAL, '<c-pageup>', ':bprev<cr>', { noremap = true })
keymap(INSERT, '<c-pagedown>', '<esc>:bnext<cr>', { noremap = true })
keymap(INSERT, '<c-pageup>', '<esc>:bprev<cr>', { noremap = true })
keymap(NORMAL, '<leader>ss', ':source ~/.config/nvim/init.lua<cr>', { noremap = true })
keymap(NORMAL, '<leader>sc', ':source %<cr>', { noremap = true })
keymap(NORMAL, '<leader>w', ':w<cr>', { noremap = true })
keymap(VISUAL, '<leader>y', '"+y<cr>', { noremap = true })
keymap(NORMAL, '<leader>yp', ':let @+=expand("%:p")<cr>', { noremap = true })
keymap(NORMAL, '<leader>yn', ':let @+=expand("%:t")<cr>', { noremap = true })
keymap(NORMAL, '<leader>yl', ':let @+=expand("%") . ":" . line(".")<cr>', { noremap = true })
keymap(VISUAL, '<leader>p', '"0p<cr>', { noremap = true })
keymap(NORMAL, '<leader>q', ':bd<cr>', { noremap = true })
keymap(NORMAL, '<leader>qq', ':qall<cr>', { noremap = true })
keymap(NORMAL, '<leader>ne', ':e %:h<cr>', { noremap = true })
keymap(NORMAL, '<c-s>', ':w<cr>', { noremap = true })
keymap(INSERT, '<c-s>', '<esc>:w<cr>a', { noremap = true })
keymap(NORMAL, '<leader>h', '<c-w>h', { noremap = true })
keymap(NORMAL, '<leader>j', '<c-w>j', { noremap = true })
keymap(NORMAL, '<leader>k', '<c-w>k', { noremap = true })
keymap(NORMAL, '<leader>l', '<c-w>l', { noremap = true })
keymap(NORMAL, '<leader>oo', '<c-w>o', { noremap = true })
keymap(NORMAL, '<leader><esc>', ':noh<cr>', { noremap = true })
keymap(NORMAL, '<c-p>', ':Telescope find_files follow=true<cr>', { noremap = true })
keymap(NORMAL, '<leader>t', ':NvimTreeToggle<cr>', { noremap = true })
keymap(NORMAL, '<leader>tf', ':NvimTreeFindFile<cr>', { noremap = true })
keymap(NORMAL, '<leader>ts', ':Telescope live_grep<cr>', { noremap = true })
keymap(NORMAL, '<leader>tt', ':Telescope file_browser path=%:p:h<cr>', { noremap = true })
keymap(NORMAL, '<leader>tb', ':Telescope buffers<cr>', { noremap = true })
keymap(NORMAL, '<leader>tm', ':Telescope media_files<cr>', { noremap = true })
keymap(NORMAL, '<leader>gc', ':Telescope git_branches<cr>', { noremap = true })
keymap(NORMAL, '<leader>gr', ':Telescope lsp_references<cr>', { noremap = true })
keymap(NORMAL, '<leader>gds', ':Telescope lsp_document_symbols<cr>', { noremap = true })
keymap(NORMAL, '<leader>gs', ':Git<cr>', { noremap = true })
keymap(NORMAL, '<leader>gp', ':Git push<cr>', { noremap = true })
keymap(NORMAL, '<leader>gg', ':Git pull<cr>', { noremap = true })
keymap(NORMAL, '<leader>gb', ':Git blame<cr>', { noremap = true })
keymap(NORMAL, '<leader>gl', ':Git log<cr>', { noremap = true })
keymap(NORMAL, '<leader>gpr', ':!gpr<cr>', { noremap = true })
keymap(NORMAL, 'gp', ':GotoParent<cr>', { noremap = true })
keymap(NORMAL, '<leader>cn', ':cnext<cr>', { noremap = true })
keymap(NORMAL, '<leader>cp', ':cprev<cr>', { noremap = true })
keymap(NORMAL, '<leader>bo', ':CloseOtherBuffers<cr>', { noremap = true })
keymap(NORMAL, '<leader>sif', ':SearchInFolder<cr>', { noremap = true })
keymap(NORMAL, '<leader>cx', ':ToggleExecutable<cr>', { noremap = true })
keymap(NORMAL, '<leader>rs', ':RunScript<cr>', { noremap = true })


-- command mode
keymap(COMMAND, '<C-a>', '<Home>', { noremap = true })
keymap(COMMAND, '<C-e>', '<End>', { noremap = true })
keymap(COMMAND, '<C-f>', '<Right>', { noremap = true })
keymap(COMMAND, '<C-b>', '<Left>', { noremap = true })
keymap(COMMAND, '<C-d>', '<Delete>', { noremap = true })
keymap(COMMAND, '<C-n>', '<Down>', { noremap = true })
keymap(COMMAND, '<C-p>', '<Up>', { noremap = true })

-- keymap(INSERT, '<C-a>', '<Home>', { noremap = true })
-- keymap(INSERT, '<C-e>', '<End>', { noremap = true })
-- keymap(INSERT, '<C-f>', '<Right>', { noremap = true })
-- keymap(INSERT, '<C-b>', '<Left>', { noremap = true })
-- keymap(INSERT, '<C-d>', '<Delete>', { noremap = true })
-- keymap(INSERT, '<C-n>', '<Down>', { noremap = true })
-- keymap(INSERT, '<C-p>', '<Up>', { noremap = true })

vim.g.AutoPairsShortcutToggle = "<leader>ap"
