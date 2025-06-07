-- only load once
if vim.g.loaded_plugin_flash then
  return
end
vim.g.loaded_plugin_flash = true

-- keymaps
local map = vim.keymap.set

map({"n", "x", "o"},"s", function() require("flash").jump() end, { desc = "Flash" })
map({ "n", "o", "x" },"S", function() require("flash").treesitter() end,{ desc = "Flash Treesitter" })
map("o", "r",function() require("flash").remote() end, {desc = "Remote Flash" })
map({ "o", "x" },"R", function() require("flash").treesitter_search() end, {desc = "Treesitter Search" })
map("c", "<c-s>",  function() require("flash").toggle() end, {desc = "Toggle Flash Search" })
