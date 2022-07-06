local hardline_ok, hardline = pcall(require, "hardline")
if not hardline_ok then
  return
end

require("hardline").setup{}
