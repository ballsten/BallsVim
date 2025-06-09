-- only load once
if vim.g.loaded_plugin_tscomments then
  return
end
vim.g.loaded_plugin_tscomments = true

-- setup
require('ts-comments').setup {
  lang = {
    nix = '# %s',
  },
}
