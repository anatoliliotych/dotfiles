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
      gitsigns.enable = true;
      fzf-lua = {
        enable = true;
        # Match the pre-nixvim fzf_layout window (0.95 in .vimrc history):
        # a centered floating window occupying 95% of the editor.
        settings = {
          winopts = {
            width = 0.95;
            height = 0.95;
            row = 0.5;
            col = 0.5;
          };
          git = {
            diff = {
              # Pre-nixvim preview, with the {1} placeholder renamed to
              # the current {file} form.
              preview = "git diff --color=always {file} | less -R";
            };
          };
        };
      };
      treesitter = {
        enable = true;
        settings = {
          ensure_installed = [
            "bash"
            "html"
            "slim"
            "css"
            "lua"
            "dockerfile"
            "vim"
            "vimdoc"
            "query"
            "markdown"
            "markdown_inline"
            "json"
            "javascript"
            "yaml"
            "ruby"
          ];
          auto_install = true;
          highlight = {
            enable = true;
          };
          indent = {
            enable = true;
          };
        };
      };
      indent-blankline = {
        enable = true;
        settings = {
          scope = {
            enabled = false;
          };
        };
      };
      which-key = {
        enable = true;
        # Pre-nixvim setup: single-line border, all default presets,
        # 500ms popup delay.
        settings = {
          win = {
            border = "single";
          };
          plugins = {
            presets = {
              operators = true;
              motions = true;
              text_objects = true;
              windows = true;
              nav = true;
              z = true;
              g = true;
            };
          };
          delay = 500;
        };
      };
      fugitive.enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>o";
        action = "<C-w>o";
        options = {
          desc = "Only keep current window";
        };
      }
      {
        mode = "n";
        key = "<leader>e";
        action = ":Ve<CR>";
        options = {
          desc = "Open netrw";
        };
      }
      {
        mode = "n";
        key = "<leader>w";
        action = ":w<CR>";
        options = {
          desc = "Save";
        };
      }
      {
        mode = "n";
        key = "<leader>q";
        action = ":q<CR>";
        options = {
          desc = "Quit";
        };
      }
      {
        mode = "n";
        key = "<C-k>";
        action = {
          __raw = "function() vim.cmd('resize +5') end";
        };
        options = {
          desc = "Increase window height by 5";
        };
      }
      {
        mode = "n";
        key = "<C-j>";
        action = {
          __raw = "function() vim.cmd('resize -5') end";
        };
        options = {
          desc = "Decrease window height by 5";
        };
      }
      {
        mode = "n";
        key = "<C-h>";
        action = {
          __raw = "function() vim.cmd('vertical resize -5') end";
        };
        options = {
          desc = "Decrease window width by 5";
        };
      }
      {
        mode = "n";
        key = "<C-l>";
        action = {
          __raw = "function() vim.cmd('vertical resize +5') end";
        };
        options = {
          desc = "Increase window width by 5";
        };
      }
      {
        mode = "n";
        key = "<C-=>";
        action = "<C-w>=";
        options = {
          noremap = true;
          desc = "Equalize all splits";
        };
      }
      {
        mode = "t";
        key = "<Esc>";
        action = "<C-\\><C-n>";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>t";
        action = {
          __raw = "function() vim.cmd('vsplit | terminal') end";
        };
        options = {
          desc = "Open terminal in vertical split";
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>T";
        action = {
          __raw = "function() vim.cmd('tabnew | terminal') end";
        };
        options = {
          desc = "Open terminal in new tab";
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = {
          __raw = "function() require('fzf-lua').files() end";
        };
        options = {
          desc = "FzfLua Files";
        };
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = {
          __raw = "function() require('fzf-lua').live_grep() end";
        };
        options = {
          desc = "FzfLua Live Grep";
        };
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = {
          __raw = "function() require('fzf-lua').buffers() end";
        };
        options = {
          desc = "FzfLua Buffers";
        };
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = {
          __raw = "function() require('fzf-lua').resume() end";
        };
        options = {
          desc = "FzfLua Resume";
        };
      }
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>vertical Git<CR>";
        options = {
          desc = "Fugitive Status";
        };
      }
      {
        mode = "n";
        key = "<leader>gb";
        action = "<cmd>G blame<CR>";
        options = {
          desc = "Fugitive Blame";
        };
      }
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

      -- In fugitive buffers, `o` opens the file under the cursor in a
      -- vertical split to the right of the status window (gO) instead of
      -- a horizontal one.  Applies to status, log, and commit buffers.
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'fugitive',
        callback = function(ev)
          vim.keymap.set('n', 'o', function()
            -- gO vsplits the status window; without splitright the file
            -- lands on its left, squeezing status into the middle.
            local old = vim.o.splitright
            vim.o.splitright = true
            vim.cmd('normal gO')
            vim.o.splitright = old
          end, { buffer = ev.buf, desc = 'Open in vertical split' })
          -- x discards the change under the cursor like X, without shift.
          vim.keymap.set('n', 'x', 'X', { buffer = ev.buf, remap = true, desc = 'Discard change' })
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
