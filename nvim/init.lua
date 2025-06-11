-- This is the entry point script for BallsVim configuration

-- set leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- set the default color scheme
require('catppuccin').setup {
  integrations = { blink_cmp = true },
}
vim.cmd.colorscheme('catppuccin-mocha')
