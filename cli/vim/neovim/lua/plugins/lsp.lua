local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
    return
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'od', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>fd', vim.lsp.buf.formatting, bufopts)
end

local language_servers = {
    gopls = {
        -- capabilities = {
        --     document_formatting = false,
        --     document_range_formatting = false,
        -- }
        -- on_attach = function(client, bufnr)
        --     on_attach(client, bufnr)
        --     client.resolved_capabilities.document_formatting = false
        --     client.resolved_capabilities.document_range_formatting = false
        -- end
    },
    -- grammarly = {},
    -- marksman = {},
    jsonls = {},
    tsserver = {},
    sumneko_lua = {
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim', 'root', 'client', 'awesome', 'screen', 'mouse', 'keyboardgrabber', 'mousegrabber' },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    -- pylsp = {
    -- }
    -- west config build.cmake-args -- -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    clangd = {},
}

local capabilities = nil


local cmp_status_ok, cmp = pcall(require, "cmp")
if cmp_status_ok and cmp ~= nil then
    local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if cmp_nvim_lsp_status_ok then
        capabilities = cmp_nvim_lsp.default_capabilities()
    end
else
    return
end

for langsvr, settings in pairs(language_servers) do
    settings = vim.tbl_deep_extend("keep", settings, {
        on_attach = on_attach,
        capabilities = capabilities,
    })
    lspconfig[langsvr].setup(settings)
end

local luasnip_status_ok, luasnip = pcall(require, "luasnip")
if cmp_status_ok and luasnip_status_ok then
    cmp.setup {
        snippet = {
            expand = function(args)
                if luasnip_status_ok then
                    luasnip.lsp_expand(args.body)
                end
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            },
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip_status_ok and luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip_status_ok and luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }),
        sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer' },
            { name = 'path' },
        },
    }
end


-- local null_ls_ok, null_ls = pcall(require, "null-ls")
-- if null_ls_ok then
--     null_ls.setup({
--         sources = {
--             -- null_ls.builtins.formatting.stylua,
--             null_ls.builtins.diagnostics.eslint,
--             null_ls.builtins.completion.spell,
--             null_ls.builtins.formatting.goimports,
--             null_ls.builtins.formatting.gofumpt,
--         },
--     })
-- end

-- golangci
-- go install https://github.com/klesh/golangci-lint-langserver
local configs = require 'lspconfig/configs'
if not configs.golangcilsp then
    configs.golangcilsp = {
        default_config = {
            cmd = { 'golangci-lint-langserver', "--debug" },
            root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
            init_options = {
                command = { "golangci-lint", "run", "--out-format", "json",
                    "--issues-exit-code=1" };
            }
        };
    }
end
lspconfig.golangci_lint_ls.setup {
    filetypes = { 'go', 'gomod' }
}

--
-- local function nvim_create_augroups(definitions)
--     for group_name, definition in pairs(definitions) do
--         vim.api.nvim_command('augroup ' .. group_name)
--         vim.api.nvim_command('autocmd!')
--         for _, def in ipairs(definition) do
--             local command = table.concat(vim.tbl_flatten { 'autocmd', def }, ' ')
--             vim.api.nvim_command(command)
--         end
--         vim.api.nvim_command('augroup END')
--     end
-- end
--
-- nvim_create_augroups({
--     go_save = {
--         { "BufWritePre", "*.go", "lua goimports(1000)" },
--     }
-- })


