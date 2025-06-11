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
  picker = {
    win = {
      input = {
        keys = {
          ['<a-c>'] = {
            'toggle_cwd',
            mode = { 'n', 'i' },
          },
          ['<a-s>'] = { 'flash', mode = { 'n', 'i' } },
          ['s'] = { 'flash' },
          ['<a-t>'] = {
            'trouble_open',
            mode = { 'n', 'i' },
          },
        },
      },
    },
    actions = {
      flash = function(picker)
        require('flash').jump {
          pattern = '^',
          label = { after = { 0, 0 } },
          search = {
            mode = 'search',
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'snacks_picker_list'
              end,
            },
          },
          action = function(match)
            local idx = picker.list:row2idx(match.pos[1])
            picker.list:_move(idx, true, true)
          end,
        }
      end,
      ---@param p snacks.Picker
      toggle_cwd = function(p)
        local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or '.')
        p:set_cwd(cwd)
        p:find()
      end,
      trouble_open = function(...)
        return require('trouble.sources.snacks').actions.trouble_open.action(...)
      end,
    },
  },
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
-- stylua: ignore start
map('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete Buffer' })
map('n', '<leader>bo', function() Snacks.bufdelete.other() end, { desc = 'Delete Other Buffers' })
map('n', '<leader>bD', '<cmd>:bd<cr>', { desc = 'Delete Buffer and Window' })
-- stylua: ignore end

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

-- picker keys
map("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
map("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
map("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
map("n", "<leader>n", function() Snacks.picker.notifications() end, { desc = "Notification History" })
-- find
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>fB", function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, { desc = "Buffers (all)" })
map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files (Root Dir)" })
map("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Files (git-files)" })
map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" })
map("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })
-- git
map("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (hunks)" })
map("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
map("n", "<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Git Stash" })
-- Grep
map("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
map("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
map("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep" })
map("n", "<leader>sp", function() Snacks.picker.lazy() end, { desc = "Search for Plugin Spec" })
map({"n", "x"}, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" })
-- search
map("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
map("n", '<leader>s/', function() Snacks.picker.search_history() end, { desc = "Search History" })
map("n", "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
map("n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command History" })
map("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
map("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
map("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
map("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
map("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
map("n", "<leader>si", function() Snacks.picker.icons() end, { desc = "Icons" })
map("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
map("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
map("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
map("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" })
map("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
map("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" })
map("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
map("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Undotree" })
-- ui
map("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
-- stylua: ignore end
