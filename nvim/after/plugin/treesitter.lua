local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

configs.setup {
  ensure_installed = {
    "bash", "html", "slim", "css", "lua", "dockerfile",
    "vim", "vimdoc", "query", "markdown", "markdown_inline",
    "json", "javascript", "yaml", "ruby",
  },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
}

