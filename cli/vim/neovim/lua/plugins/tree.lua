local nvim_tree_ok, nvim_tree = pcall(require, "nvim-tree")
if nvim_tree_ok then
    nvim_tree.setup {
        actions = {
            change_dir = {
                global = true
            }
        },
        git = {
            ignore = false
        }
    }
end

local _, nvim_tree_view = pcall(require, "nvim-tree/view")
local _, nvim_tree_lib = pcall(require, "nvim-tree/lib")
-- local _, nvim_tree_reloaders = pcall(require, "nvim-tree/actions/reloaders/reloaders")

local function is_in_nvim_tree_buf()
    if not nvim_tree_ok then
        return false
    end
    local curwin = vim.api.nvim_get_current_win()
    local curbuf = vim.api.nvim_win_get_buf(curwin)
    local bufname = vim.api.nvim_buf_get_name(curbuf)
    return bufname:match "NvimTree"
end

local function get_absolute_path(absolute_path)
    if absolute_path == "" then
        if is_in_nvim_tree_buf() then
            absolute_path = nvim_tree_lib.get_node_at_cursor().absolute_path
        else
            absolute_path = vim.fn.expand("%:p")
        end
    end
    return absolute_path
end

-- ToggleExecutable
function ToggleExecutable(absolute_path, executable)
    absolute_path = get_absolute_path(absolute_path)
    if executable == nil then
        executable = not vim.loop.fs_access(absolute_path, "X")
    end
    if executable then
        vim.cmd(":!chmod +x " .. absolute_path)
    else
        vim.cmd(":!chmod -x " .. absolute_path)
    end
    if nvim_tree_ok then
        -- nvim_tree_reloaders
        vim.cmd(":NvimTreeRefresh")
    end
end

vim.api.nvim_create_user_command("ToggleExecutable", function(res)
    ToggleExecutable(res.args)
end, { nargs = "?" })
