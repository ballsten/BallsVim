-- only load once
if vim.g.loaded_plugin_snacks then
  return
end
vim.g.loaded_plugin_snacks = true

-- Terminal Mappings
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and '<c-' .. dir .. '>' or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

-- snack options
require('snacks').setup {
  bigfile = { enabled = true },
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
        { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
        { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
        { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
        { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
      },
    },
    formats = {
      header = { '%s', align = 'center' },
    },
    sections = {
      { section = 'header' },
      { section = 'keys' },
    },
  },
  explorer = {
    replace_netrw = true,
  },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  terminal = {
    win = {
      keys = {
        nav_h = { '<C-h>', term_nav('h'), desc = 'Go to Left Window', expr = true, mode = 't' },
        nav_j = { '<C-j>', term_nav('j'), desc = 'Go to Lower Window', expr = true, mode = 't' },
        nav_k = { '<C-k>', term_nav('k'), desc = 'Go to Upper Window', expr = true, mode = 't' },
        nav_l = { '<C-l>', term_nav('l'), desc = 'Go to Right Window', expr = true, mode = 't' },
      },
    },
  },
  toggle = { enabled = true },
  words = { enabled = true },
}

-- keymaps
local map = vim.keymap.set

-- buffers
map('n', '<leader>bd', function()
  Snacks.bufdelete()
end, { desc = 'Delete Buffer' })
map('n', '<leader>bo', function()
  Snacks.bufdelete.other()
end, { desc = 'Delete Other Buffers' })
map('n', '<leader>bD', '<cmd>:bd<cr>', { desc = 'Delete Buffer and Window' })

-- toggle options
-- TODO not sure about these
-- LazyVim.format.snacks_toggle():map("<leader>uf")
-- LazyVim.format.snacks_toggle(true):map("<leader>uF")
Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
Snacks.toggle.diagnostics():map('<leader>ud')
Snacks.toggle.line_number():map('<leader>ul')
Snacks.toggle
  .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = 'Conceal Level' })
  :map('<leader>uc')
Snacks.toggle
  .option('showtabline', { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = 'Tabline' })
  :map('<leader>uA')
Snacks.toggle.treesitter():map('<leader>uT')
Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
Snacks.toggle.dim():map('<leader>uD')
Snacks.toggle.animate():map('<leader>ua')
Snacks.toggle.indent():map('<leader>ug')
Snacks.toggle.scroll():map('<leader>uS')
Snacks.toggle.profiler():map('<leader>dpp')
Snacks.toggle.profiler_highlights():map('<leader>dph')
if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map('<leader>uh')
end
Snacks.toggle({
  name = 'Git Signs',
  get = function()
    return require('gitsigns.config').config.signcolumn
  end,
  set = function(state)
    require('gitsigns').toggle_signs(state)
  end,
}):map('<leader>uG')

-- lazygit
-- stylua: ignore start
if vim.fn.executable('lazygit') == 1 then
  map('n', '<leader>gg', function() Snacks.lazygit() end, { desc = 'Lazygit' })
  map('n', '<leader>gf', function() Snacks.picker.git_log_file() end, { desc = 'Git Current File History' })
  map('n', '<leader>gl', function() Snacks.picker.git_log() end, { desc = 'Git Log' })
end

map('n', '<leader>gb', function() Snacks.picker.git_log_line() end, { desc = 'Git Blame Line' })
map({ 'n', 'x' }, '<leader>gB', function() Snacks.gitbrowse() end, { desc = 'Git Browse (open)' })
---@diagnostic disable-next-line: missing-fields
map({ 'n', 'x' }, '<leader>gY', function() Snacks.gitbrowse {
  open = function(url) vim.fn.setreg('+', url) end,
  notify = false,
} end, { desc = 'Git Browse (copy)' })

-- terimal keys
map('n', '<leader>.', function() Snacks.scratch() end, { desc = 'Toggle Scratch Buffer' })
map('n', '<leader>S', function() Snacks.scratch.select() end, { desc = 'Select Scratch Buffer' })
map('n', '<leader>dps', function() Snacks.profiler.scratch() end, { desc = 'Profiler Scratch Buffer' })
-- stylua: ignore end
