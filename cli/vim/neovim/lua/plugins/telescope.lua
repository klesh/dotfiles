local telescope_ok, telescope = pcall(require, "telescope")
if not telescope_ok then
  return
end

-- telescope.load_extension "file_browser"
local actions = require("telescope.actions")
telescope.load_extension('media_files')
telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<esc>"] = actions.close,
            },
        },
    },
    extensions = {
        -- file_browser = {}
        media_files = {}
    }
})
