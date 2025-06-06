-- only load once
if vim.g.loaded_plugin_snacks then
  return
end

vim.g.loaded_plugin_snacks = true

-- snack options
require("snacks").setup({
  bigfile = { enabled = true},
  dashboard = {
    preset = {
      header = [[
███████████            ████  ████          █████   █████  ███                 
░░███░░░░░███          ░░███ ░░███         ░░███   ░░███  ░░░                  
░███    ░███  ██████   ░███  ░███   █████  ░███    ░███  ████  █████████████  
░██████████  ░░░░░███  ░███  ░███  ███░░   ░███    ░███ ░░███ ░░███░░███░░███ 
░███░░░░░███  ███████  ░███  ░███ ░░█████  ░░███   ███   ░███  ░███ ░███ ░███ 
░███    ░███ ███░░███  ░███  ░███  ░░░░███  ░░░█████░    ░███  ░███ ░███ ░███ 
███████████ ░░████████ █████ █████ ██████     ░░███      █████ █████░███ █████
░░░░░░░░░░░   ░░░░░░░░ ░░░░░ ░░░░░ ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░ 
]],
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    formats = {
      header = { "%s", align = "center" },
    },
    sections = {
      { section = "header" },
      { section = "keys" },
    },
  },
  explorer = {
    replace_netrw = true
  },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  toggle = { enabled = true },
  words = { enabled = true },
})

-- keymaps
local map = vim.keymap.set

-- buffers
map("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function()
  Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- toggle options
-- TODO not sure about these
-- LazyVim.format.snacks_toggle():map("<leader>uf")
-- LazyVim.format.snacks_toggle(true):map("<leader>uF")
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark" , name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.animate():map("<leader>ua")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.scroll():map("<leader>uS")
Snacks.toggle.profiler():map("<leader>dpp")
Snacks.toggle.profiler_highlights():map("<leader>dph")
if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map("<leader>uh")
end

-- lazygit
if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
  map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Current File History" })
  map("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log" })
end

map("n", "<leader>gb", function() Snacks.picker.git_log_line() end, { desc = "Git Blame Line" })
map({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse (open)" })
map({"n", "x" }, "<leader>gY", function()
  Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
end, { desc = "Git Browse (copy)" })
