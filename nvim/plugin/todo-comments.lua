-- only load once
if vim.g.loaded_plugin_todocomments then
  return
end
vim.g.loaded_plugin_todocomments = true

-- keymaps
local map = vim.keymap.set

map('n', ']t', function()
  require('todo-comments').jump_next()
end, { desc = 'Next Todo Comment' })
map('n', '[t', function()
  require('todo-comments').jump_prev()
end, { desc = 'Previous Todo Comment' })
map('n', '<leader>xt', '<cmd>Trouble todo toggle<cr>', { desc = 'Todo (Trouble)' })
map(
  'n',
  '<leader>xT',
  '<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>',
  { desc = 'Todo/Fix/Fixme (Trouble)' }
)
map('n', '<leader>st', '<cmd>TodoTelescope<cr>', { desc = 'Todo' })
map('n', '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>', { desc = 'Todo/Fix/Fixme' })
