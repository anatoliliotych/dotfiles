local Plug = vim.fn['plug#']
vim.call('plug#begin', vim.fn.expand('~/.config/nvim/plugged'))

Plug 'bling/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'ggml-org/llama.vim'
Plug 'ibhagwan/fzf-lua'
Plug('sonph/onehalf', { rtp = 'vim' })

vim.call('plug#end')

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

vim.keymap.set("n", "<leader>ff", function()
  require("fzf-lua").files()
end, { desc = "FzfLua Files" })

vim.keymap.set("n", "<leader>fg", function()
  require("fzf-lua").live_grep()
end, { desc = "FzfLua Files" })
