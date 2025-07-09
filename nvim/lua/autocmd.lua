vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.opt_local.formatoptions:remove({'c', 'r', 'o'})
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
})

vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = '*',
  callback = function()
    vim.opt_local.eol = false
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = function()
    vim.fn.matchadd('ErrorMsg', '\\%>80v.\\+', -1)
  end,
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = '*.slim',
  callback = function()
    vim.bo.filetype = 'slim'
  end,
})

