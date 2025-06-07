-- only load once
if vim.g.loaded_plugin_lualine then
  return
end
vim.g.loaded_plugin_lualine = true

-- setup
require("lualine").setup{}
