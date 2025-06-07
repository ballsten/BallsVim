-- only load once
if vim.g.loaded_plugin_grugfar then
  return
end
vim.g.loaded_plugin_grugfar = true

-- setup options
require('grug-far').setup {
  headerMaxWidth = 80,
}

-- keymaps
local map = vim.keymap.set

map({ 'n', 'v' }, '<leader>sr', function()
  local grug = require('grug-far')
  local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
  grug.open {
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
    },
  }
end, { desc = 'Search and replace' })
