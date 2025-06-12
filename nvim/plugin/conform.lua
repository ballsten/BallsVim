-- only load once
if vim.g.loaded_plugin_conform then
  return
end
vim.g.loaded_plugin_conform = true

-- setup
local opts = {
  default_format_opts = {
    timeout_ms = 3000,
    async = false, -- not recommended to change
    quiet = false, -- not recommended to change
    lsp_format = 'fallback', -- not recommended to change
  },
  formatters_by_ft = {},
  format_on_save = {
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
}

-- add formatters if availabile
if vim.fn.executable('stylua') == 1 then
  opts.formatters_by_ft.lua = { 'stylua' }
end
if vim.fn.executable('nixd') == 1 then
  opts.formatters_by_ft.nix = { 'nixfmt' }
end
if vim.fn.executable('biome') == 1 then
  -- filetypes supported by biome
  local supported = {
    'astro',
    'css',
    'graphql',
    -- "html",
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    -- "markdown",
    'svelte',
    'typescript',
    'typescriptreact',
    'vue',
    -- "yaml",
  }
  -- add biome for each supported filetype
  opts.formatters_by_ft = opts.formatters_by_ft or {}
  for _, ft in ipairs(supported) do
    opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
    table.insert(opts.formatters_by_ft[ft], 'biome')
  end
end

require('conform').setup(opts)

-- keymaps
local map = vim.keymap.set

map({ 'n', 'v' }, '<leader>cF', function()
  require('conform').format { formatters = { 'injected' }, timeout_ms = 3000 }
end, { desc = 'Format Injected Langs' })
