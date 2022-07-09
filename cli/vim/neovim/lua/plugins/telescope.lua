local telescope_ok, telescope = pcall(require, "telescope")
if not telescope_ok then
  return
end

-- telescope.load_extension "file_browser"
telescope.load_extension('media_files')
telescope.setup({
        extensions = {
                -- file_browser = {}
                media_files = {}
        }
})
