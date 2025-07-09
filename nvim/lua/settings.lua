local o = vim.o
local g = vim.g

-- Basic editor setup
vim.cmd('colorscheme onehalfdark')
vim.cmd([[highlight default link SignColumn LineNr]])
o.timeoutlen = 250

-- Line numbers and display
o.relativenumber = true
o.number = true
o.wrap = false
o.list = true
o.listchars = 'tab:▸ ,eol:¬,trail:∙'

-- Search settings
o.ignorecase = true
o.smartcase = true
o.path = o.path .. '**'

-- Tab and indentation
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = true
o.smarttab = true
o.smartindent = true

-- Folding
o.foldenable = false
o.foldmethod = 'indent'

-- File handling
o.writebackup = false
o.swapfile = false

-- Clipboard
o.clipboard = 'unnamedplus,unnamed'

-- Netrw (file explorer)
g.netrw_banner = 0
g.netrw_browse_split = 2
g.netrw_winsize = 40

-- Plugins
g.airline_theme='onehalfdark'
