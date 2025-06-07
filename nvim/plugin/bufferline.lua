-- only load once
if vim.g.loaded_plugin_bufferline then
  return
end
vim.g.loaded_plugin_bufferline = true

-- setup
require('bufferline').setup {
  options = {
      -- stylua: ignore
      close_command = function(n) Snacks.bufdelete(n) end,
      -- stylua: ignore
      right_mouse_command = function(n) Snacks.bufdelete(n) end,
    diagnostics = 'nvim_lsp',
    always_show_bufferline = false,
    diagnostics_indicator = function(_, _, diag)
      local icons = require("BallsVim").icons.diagnostics
      local ret = (diag.error and icons.Error .. diag.error .. ' ' or '')
        .. (diag.warning and icons.Warn .. diag.warning or '')
      return vim.trim(ret)
    end,
    offsets = {
      {
        filetype = 'neo-tree',
        text = 'Neo-tree',
        highlight = 'Directory',
        text_align = 'left',
      },
      {
        filetype = 'snacks_layout_box',
      },
    },
    get_element_icon = function(element)
      local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
      return icon, hl
    end,
  },
}

-- keymaps
local map = vim.keymap.set

map('n', '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', { desc = 'Toggle Pin' })
map('n', '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', { desc = 'Delete Non-Pinned Buffers' })
map('n', '<leader>br', '<Cmd>BufferLineCloseRight<CR>', { desc = 'Delete Buffers to the Right' })
map('n', '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', { desc = 'Delete Buffers to the Left' })
map('n', '<S-h>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev Buffer' })
map('n', '<S-l>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next Buffer' })
map('n', '[b', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev Buffer' })
map('n', ']b', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next Buffer' })
map('n', '[B', '<cmd>BufferLineMovePrev<cr>', { desc = 'Move buffer prev' })
map('n', ']B', '<cmd>BufferLineMoveNext<cr>', { desc = 'Move buffer next' })
