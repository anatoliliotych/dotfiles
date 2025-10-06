local Plug = vim.fn['plug#']
vim.call('plug#begin', vim.fn.expand('~/.config/nvim/plugged'))
Plug 'bling/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'ggml-org/llama.vim'
Plug 'ibhagwan/fzf-lua'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'folke/which-key.nvim'
Plug 'tpope/vim-fugitive'
Plug('sonph/onehalf', { rtp = 'vim' })
vim.call('plug#end')

require("ibl").setup({
  scope = {
    enabled = false,
  },
})

require("fzf-lua").setup {
  winopts = {
    fullscreen = true,
  },
  git = {
    diff = {
      preview = "git diff --color=always {1} | less -R",
    },
  },
}

require("which-key").setup({
  win = { border = "single" },
  plugins = {
    presets = {
      operators = true, -- adds help for operators like d, y, ...
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true -- bindings for prefixed with g
    }
  },
  delay = 500
})

require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "bash",
    "html",
    "slim",
    "css",
    "lua",
    "dockerfile",
    "vim",
    "vimdoc",
    "query",
    "markdown",
    "markdown_inline",
    "json",
    "javascript",
    "yaml",
    "ruby",
  },

  auto_install = true,

  highlight = { enable = true },
  indent = { enabled = true },
}
