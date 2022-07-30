local dap_go_ok, dap_go = pcall(require, "dap-go")
if dap_go_ok then
    dap_go.setup()
end


local dap_ok, dap = pcall(require, "dap")
if dap_ok then
    dap.defaults.fallback.terminal_win_cmd = '20split new'
    -- vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
    -- vim.fn.sign_define('DapBreakpointRejected', { text = '🟦', texthl = '', linehl = '', numhl = '' })
    -- vim.fn.sign_define('DapStopped', { text = '⭐️', texthl = '', linehl = '', numhl = '' })
end
-- dap.adapters.node2 = {
--   type = 'executable',
--   command = 'node',
--   args = {os.getenv('HOME') .. '/apps/node/out/src/nodeDebug.js'},
-- }

-- require('dap').set_log_level('INFO')

local telescope_ok, telescope = pcall(require, "telescope")
if telescope_ok then
    telescope.load_extension("dap")
end
