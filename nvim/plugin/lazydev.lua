-- only load once
if vim.g.loaded_plugin_lazydev then
  return
end
vim.g.loaded_plugin_lazydev = true

require('lazydev').setup {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    { path = 'snacks.nvim', words = { 'Snacks' } },
  },
}
