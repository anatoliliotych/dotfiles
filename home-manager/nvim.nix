{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    nixpkgs.source = pkgs.path;

    extraPlugins = [
      pkgs.vimPlugins.onehalf
      pkgs.vimPlugins.llama-vim
    ];

    globals = {
      mapleader = " ";
      netrw_banner = 0;
      netrw_browse_split = 2;
      netrw_winsize = 40;
    };

    opts = {
      timeoutlen = 500;
      number = true;
      relativenumber = true;
      wrap = false;
      list = true;
      listchars = "tab:▸ ,eol:¬,trail:∙";
      ignorecase = true;
      smartcase = true;
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      smarttab = true;
      smartindent = true;
      foldenable = false;
      foldmethod = "indent";
      writebackup = false;
      swapfile = false;
      clipboard = "unnamedplus,unnamed";
    };

    plugins = {
      airline.enable = true;
      gitgutter.enable = true;
      fzf-lua.enable = true;
      treesitter = {
        enable = true;
        settings = {
          ensure_installed = [
            "bash" "html" "slim" "css" "lua" "dockerfile"
            "vim" "vimdoc" "query" "markdown" "markdown_inline"
            "json" "javascript" "yaml" "ruby"
          ];
          auto_install = true;
          highlight = { enable = true; };
          indent = { enable = true; };
        };
      };
      indent-blankline.enable = true;
      which-key.enable = true;
      fugitive.enable = true;
    };

    keymaps = [
      { mode = "n"; key = "<leader>o"; action = "<C-w>o"; options = { desc = "Only keep current window"; }; }
      { mode = "n"; key = "<leader>e"; action = ":Ve<CR>"; options = { desc = "Open netrw"; }; }
      { mode = "n"; key = "<leader>w"; action = ":w<CR>"; options = { desc = "Save"; }; }
      { mode = "n"; key = "<leader>q"; action = ":q<CR>"; options = { desc = "Quit"; }; }
      { mode = "n"; key = "<C-k>"; action = { __raw = "function() vim.cmd('resize +5') end"; }; options = { desc = "Increase window height by 5"; }; }
      { mode = "n"; key = "<C-j>"; action = { __raw = "function() vim.cmd('resize -5') end"; }; options = { desc = "Decrease window height by 5"; }; }
      { mode = "n"; key = "<C-h>"; action = { __raw = "function() vim.cmd('vertical resize -5') end"; }; options = { desc = "Decrease window width by 5"; }; }
      { mode = "n"; key = "<C-l>"; action = { __raw = "function() vim.cmd('vertical resize +5') end"; }; options = { desc = "Increase window width by 5"; }; }
      { mode = "n"; key = "<C-=>"; action = "<C-w>="; options = { noremap = true; desc = "Equalize all splits"; }; }
      { mode = "t"; key = "<Esc>"; action = "<C-\\><C-n>"; options = { noremap = true; silent = true; }; }
      { mode = "n"; key = "<leader>t"; action = { __raw = "function() vim.cmd('vsplit | terminal') end"; }; options = { desc = "Open terminal in vertical split"; noremap = true; silent = true; }; }
      { mode = "n"; key = "<leader>T"; action = { __raw = "function() vim.cmd('tabnew | terminal') end"; }; options = { desc = "Open terminal in new tab"; noremap = true; silent = true; }; }
      { mode = "n"; key = "<leader>ff"; action = { __raw = "function() require('fzf-lua').files() end"; }; options = { desc = "FzfLua Files"; }; }
      { mode = "n"; key = "<leader>fg"; action = { __raw = "function() require('fzf-lua').live_grep() end"; }; options = { desc = "FzfLua Live Grep"; }; }
      { mode = "n"; key = "<leader>fb"; action = { __raw = "function() require('fzf-lua').buffers() end"; }; options = { desc = "FzfLua Buffers"; }; }
      { mode = "n"; key = "<leader>fr"; action = { __raw = "function() require('fzf-lua').resume() end"; }; options = { desc = "FzfLua Resume"; }; }
    ];

    extraConfigLua = ''
      vim.cmd('colorscheme onehalfdark')
      vim.cmd([[highlight default link SignColumn LineNr]])
      vim.g.airline_theme = 'onehalfdark'

      local function set_whichkey_highlights()
        vim.cmd [[
          highlight WhichKeyNormal guibg=#353b45 guifg=#dcdfe4
          highlight WhichKeyFloat  guibg=#353b45 guifg=#dcdfe4
          highlight WhichKeyBorder guibg=#353b45 guifg=#61afef
        ]]
      end
      set_whichkey_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = set_whichkey_highlights,
      })

      vim.o.path = vim.o.path .. '**'

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
    '';
  };
}
