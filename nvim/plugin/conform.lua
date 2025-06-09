-- only load once
if vim.g.loaded_plugin_conform then
  return
end
vim.g.loaded_plugin_conform = true

-- setup
require('conform').setup {
  default_format_opts = {
    timeout_ms = 3000,
    async = false, -- not recommended to change
    quiet = false, -- not recommended to change
    lsp_format = 'fallback', -- not recommended to change
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    nix = { 'nixfmt' },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
}

-- keymaps
local map = vim.keymap.set

map({ 'n', 'v' }, '<leader>cF', function()
  require('conform').format { formatters = { 'injected' }, timeout_ms = 3000 }
end, { desc = 'Format Injected Langs' })
