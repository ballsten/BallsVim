-- only load once
if vim.g.loaded_plugin_noice then
  return
end
vim.g.loaded_plugin_noice = true

-- setup
require('noice').setup {
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
  },
  routes = {
    {
      filter = {
        event = 'msg_show',
        any = {
          { find = '%d+L, %d+B' },
          { find = '; after #%d+' },
          { find = '; before #%d+' },
        },
      },
      view = 'mini',
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
  },
}

-- keymaps
local map = vim.keymap.set

map('n', '<leader>sn', '', { desc = '+noice' })
map('c', '<S-Enter>', function()
  require('noice').redirect(vim.fn.getcmdline())
end, { desc = 'Redirect Cmdline' })
map('n', '<leader>snl', function()
  require('noice').cmd('last')
end, { desc = 'Noice Last Message' })
map('n', '<leader>snh', function()
  require('noice').cmd('history')
end, { desc = 'Noice History' })
map('n', '<leader>sna', function()
  require('noice').cmd('all')
end, { desc = 'Noice All' })
map('n', '<leader>snd', function()
  require('noice').cmd('dismiss')
end, { desc = 'Dismiss All' })
map({ 'n', 'i', 's' }, '<c-f>', function()
  if not require('noice.lsp').scroll(4) then
    return '<c-f>'
  end
end, { silent = true, expr = true, desc = 'Scroll Forward' })
map({ 'n', 'i', 's' }, '<c-b>', function()
  if not require('noice.lsp').scroll(-4) then
    return '<c-b>'
  end
end, { silent = true, expr = true, desc = 'Scroll Backward' })
