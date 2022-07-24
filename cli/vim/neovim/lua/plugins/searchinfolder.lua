local nvim_tree_lib_ok, nvim_tree_lib = pcall(require, "nvim-tree/lib")
if not nvim_tree_lib_ok then
    return
end
local telescope_builtin_ok, telescope_builtin = pcall(require, "telescope/builtin")
if not telescope_builtin_ok then
  return
end

function SearchInFolder(folder_path)
    if folder_path == "" then
        local folder = nvim_tree_lib.get_node_at_cursor()
        if folder == nil then
            folder_path = vim.fn.expand("%:p:h")
        else
            if assert(folder.fs_stat).type == "file" then
                folder = folder.parent
            end
            folder_path = folder.absolute_path
        end
    end
    telescope_builtin.live_grep{cwd = folder_path}
    -- print(vim.inspect(folder_path))
end

vim.api.nvim_create_user_command("SearchInFolder", function(res)
    SearchInFolder(res.args)
end, { nargs = "?" })

