-- only load once
if vim.g.loaded_plugin_todocomments then
  return
end
vim.g.loaded_plugin_todocomments = true

-- setup
require('todo-comments').setup()

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

-- stylua: ignore start
---@diagnostic disable-next-line: undefined-field
map('n', '<leader>st', function() Snacks.picker.todo_comments() end, { desc = 'Todo' })
---@diagnostic disable-next-line: undefined-field
map('n', '<leader>sT', function() Snacks.picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } } end, { desc = 'Todo/Fix/Fixme' })
-- stylua: ignore end
