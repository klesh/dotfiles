local bufferline_ok, bufferline = pcall(require, "bufferline")
if not bufferline_ok then
  return
end

vim.o.termguicolors = true
require("bufferline").setup{}
