local nvim_tree_ok, nvim_tree = pcall(require, "nvim-tree")
if not nvim_tree_ok then
  return
end

nvim_tree.setup{
        actions = {
                change_dir = {
                        global = true
                }
        }
}

