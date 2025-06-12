-- only load once
if vim.g.loaded_plugin_nonels then
  return
end
vim.g.loaded_plugin_nonels = true

-- setup
local null_ls = require('null-ls')

-- options
local opts = {
  sources = {},
}

-- add sources based on availability of tools
if vim.fn.executable('stylua') then
  table.insert(opts.sources, null_ls.builtins.formatting.stylua)
end

if vim.fn.executable('biome') then
  table.insert(opts.sources, null_ls.builtins.formatting.biome)
end

null_ls.setup {
  sources = {
    null_ls.builtins.formatting.biome,
  },
}
