-- === options ===
vim.opt.completeopt = 'menu,menuone,noselect,popup,fuzzy'
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.winborder = 'single'
vim.opt.termguicolors = true

vim.opt.foldcolumn = "3"
vim.opt.foldmethod = "expr"
vim.opt.signcolumn = "yes"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

vim.opt.swapfile = false
vim.opt.wrap = false
vim.opt.grepprg = "rg"
vim.opt.clipboard = 'unnamedplus'

vim.g.mapleader = ' '
vim.cmd('colorscheme retrobox')

-- === yank highlight ===
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  desc = 'Hightlight selection on yank',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 100 }
  end,
})

-- === keymaps ===
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', 'U', '<cmd>redo<CR>')
vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format() end)
vim.keymap.set('n', '<leader>bd', '<cmd>bd<CR>')
vim.keymap.set('n', '<leader>sf', '<cmd>Pick files<CR>')
vim.keymap.set('n', '<leader>sg', '<cmd>Pick grep_live<CR>')
vim.keymap.set('n', '<leader>sh', '<cmd>Pick help<CR>')
vim.keymap.set('n', '<leader><leader>', '<cmd>Pick buffers<CR>')
vim.keymap.set('n', '<leader>e', function() MiniFiles.open() end)
vim.keymap.set('n', '<leader>g', '<cmd>LazyGit<CR>')
vim.keymap.set('i', '<C-Space>', function() vim.lsp.completion.get() end)
vim.keymap.set('i', '<CR>', function()
  if vim.fn.pumvisible() == 1 and vim.fn.complete_info().selected ~= -1 then
    return vim.api.nvim_replace_termcodes('<C-y>', true, true, true)
  end
  return vim.api.nvim_replace_termcodes('<CR>', true, true, true)
end, { expr = true, silent = true })

-- === lsp ===
function on_attach(client, bufnr)
  vim.lsp.completion.enable(true, client.id, bufnr, {
    autotrigger = false,
    convert = function(item)
      if item.label then
        item.abbr = item.label:gsub('%b()', '')
      end
      return item
    end,
  })
end

vim.lsp.config['jsonls'] = {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  on_attach = on_attach
}
vim.lsp.config['clangd'] = {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'h', 'hpp' },
  on_attach = on_attach
}
vim.lsp.config['gopls'] = {
  cmd = { 'gopls' },
  filetypes = { 'go' },
  on_attach = on_attach
}
vim.lsp.config['zls'] = {
  cmd = { 'zls' },
  filetypes = { 'zig' },
  on_attach = on_attach
}
vim.lsp.enable('jsonls')
vim.lsp.enable('clangd')
vim.lsp.enable('gopls')
vim.lsp.enable('zls')

require('mini.pick').setup({
  source = { show = require('mini.pick').default_show }
})
require('mini.files').setup({
  windows = { preview = true }
})

require('colorizer').setup()


-- <<< START FLAVOURS >>>
-- Citrus scheme by sorb852
--
-- lowk js a cheat

require('base16-colorscheme').setup({
    base00 = '#0e1014',
    base01 = '#282a2d',
    base02 = '#424547',
    base03 = '#5c5f60',
    base04 = '#77797a',
    base05 = '#919393',
    base06 = '#abaead',
    base07 = '#c5c8c6',
    base08 = '#ff700f',
    base09 = '#f9a824',
    base0A = '#fdd41d',
    base0B = '#ceff1f',
    base0C = '#1fff57',
    base0D = '#1fff75',
    base0E = '#d8466f',
    base0F = '#ea3458',
})
-- <<< END FLAVOURS >>>

local default_cols = { fg = require('base16-colorscheme').colors.base07, bg = require('base16-colorscheme').colors.base01 }
local line = {
  a = { fg = require('base16-colorscheme').colors.base00, bg = require('base16-colorscheme').colors.base09, gui = 'bold' },
  b = default_cols,
  c = default_cols,
  x = default_cols,
  y = { fg = require('base16-colorscheme').colors.base07, bg = require('base16-colorscheme').colors.base01 },
  z = { fg = require('base16-colorscheme').colors.base00, bg = require('base16-colorscheme').colors.base09, gui = 'bold' },
}
require('lualine').setup({
  options = {
    theme = {
      normal = line,
      insert = line,
      replace = line,
      command = line,
      inactive = line
    },
    icons_enabled = false,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {'branch'},
    lualine_z = {'filename'}
  }
})

