{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    nixpkgs.source = pkgs.path;

    extraPlugins = [
      pkgs.vimPlugins.llama-vim
    ];

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "frappe";
        integrations = {
          gitsigns = true;
          which_key = true;
          indent_blankline = true;
          flash = true;
        };
        # The default ColorColumn (surface0) is nearly invisible against
        # the editor background; @red is the palette's warning accent and
        # matches what the old over-length highlight used. Named palette
        # colors, so this still follows the flavour.
        custom_highlights = {
          __raw = ''
            function(colors)
              return {
                ColorColumn = { bg = colors.red },
              }
            end
          '';
        };
      };
    };

    globals = {
      mapleader = " ";
      netrw_banner = 0;
      netrw_browse_split = 2;
      netrw_winsize = 40;
      # llama.vim FIM keys: plain Ctrl chords (leader chords and S-Tab
      # do not fit insert mode on the Corne; the plugin merges these
      # over its defaults).  C-l/C-b are unbound in insert mode.  The
      # trigger is disabled: auto_fim already fires completions.
      llama_config = {
        keymap_fim_trigger = "";
        keymap_fim_accept_line = "<C-l>";
        keymap_fim_accept_word = "<C-b>";
      };
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
      # Persistent undo: keep the history in nvim's state dir (the
      # nvim default location) so it survives closing a buffer.
      undofile = true;
      undodir = {
        __raw = ''vim.fn.stdpath("state") .. "/undo"'';
      };
      # Reclaim the command line row; messages still show on demand.
      cmdheight = 0;
      clipboard = "unnamedplus,unnamed";
    };

    plugins = {
      lualine = {
        enable = true;
        settings = {
          options.theme = "catppuccin-nvim";
          sections = {
            # Drop the fileformat icon (renders as a penguin glyph for
            # unix line endings) and the diff git-changes counter.
            lualine_b = [
              "branch"
              "diagnostics"
            ];
            lualine_x = [
              "encoding"
              "filetype"
            ];
          };
        };
      };
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
      # Enabling flash already upgrades f/F/t/T with jump labels; the
      # jump keymaps below are the parts it leaves to the user.
      flash = {
        enable = true;
        settings = {
          # Labels on / and ? too. Off upstream because it is meant to be
          # toggled with <C-s>, which is a same-hand home-row chord that
          # does not fire on the Corne, so it is enabled outright instead.
          modes.search.enabled = true;
          # Labels on f/F/t/T as well, so any match is one keypress away
          # instead of repeating the motion. flash keeps hjkliardc out of
          # the label pool, so d/c/i/a still work right after the motion.
          modes.char.jump_labels = true;
        };
      };
      lazygit = {
        enable = true;
        settings = {
          # 0.95 to match the fzf-lua window and the tmux-fzf popup.
          floating_window_scaling_factor = 0.95;
        };
      };
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
      # flash.nvim.  Upstream uses S and <C-s>, both of which are
      # same-hand home-row chords that do not fire on the Corne, so
      # treesitter select moves to <leader>s (Space is a thumb) and the
      # search toggle is left out.  o-mode r does not clash with normal
      # mode r (replace char).
      {
        mode = [ "n" "x" "o" ];
        key = "s";
        action = {
          __raw = "function() require('flash').jump() end";
        };
        options = {
          desc = "Flash Jump";
        };
      }
      {
        mode = [ "n" "x" "o" ];
        key = "<leader>s";
        action = {
          __raw = "function() require('flash').treesitter() end";
        };
        options = {
          desc = "Flash Treesitter Select";
        };
      }
      {
        mode = "o";
        key = "r";
        action = {
          __raw = "function() require('flash').remote() end";
        };
        options = {
          desc = "Flash Remote";
        };
      }
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<CR>";
        options = {
          desc = "LazyGit";
        };
      }
      {
        # lazygit has no blame view; gitsigns (already enabled) provides
        # the closest equivalent to the old :G blame.
        mode = "n";
        key = "<leader>gb";
        action = {
          __raw = "function() require('gitsigns').blame_line({ full = true }) end";
        };
        options = {
          desc = "Gitsigns Blame Line";
        };
      }
      {
        # Walk the working-tree diff without leaving the buffer. nav_hunk
        # honors 'wrapscan', so past the last hunk it cycles to the first.
        mode = "n";
        key = "<leader>gn";
        action = {
          __raw = "function() require('gitsigns').nav_hunk('next') end";
        };
        options = {
          desc = "Gitsigns Next Hunk";
        };
      }
      {
        mode = "n";
        key = "<leader>gp";
        action = {
          __raw = "function() require('gitsigns').nav_hunk('prev') end";
        };
        options = {
          desc = "Gitsigns Previous Hunk";
        };
      }
    ];

    extraConfigLua = ''
      vim.cmd([[highlight default link SignColumn LineNr]])

      vim.o.path = vim.o.path .. '**'

      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function()
          vim.opt_local.formatoptions:remove({'c', 'r', 'o'})
        end,
      })

      -- In netrw, `o` splits horizontally and ignores netrw_browse_split.
      -- Route it through the <CR> handler instead, which honors
      -- netrw_browse_split=2, and flip splitright so the file window
      -- opens to the right of the netrw window.
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'netrw',
        callback = function(ev)
          vim.keymap.set('n', 'o', function()
            local old = vim.o.splitright
            vim.o.splitright = true
            vim.api.nvim_feedkeys(
              vim.api.nvim_replace_termcodes('<Plug>NetrwLocalBrowseCheck', true, true, true),
              'xt', false
            )
            vim.o.splitright = old
          end, { buffer = ev.buf, desc = 'Open file in vertical split to the right' })
        end,
      })

      -- Guide line at column 120, file buffers only.  colorcolumn is
      -- window-local, so this also clears the line again for anything
      -- that is not editable code.  A non-empty buftype covers terminals
      -- (lazygit) and help; netrw needs the filetype check because it
      -- leaves buftype empty, and FileType is in the event list because
      -- netrw only sets its filetype after BufWinEnter has fired.
      local nocolumn = { netrw = true }
      vim.api.nvim_create_autocmd({'BufWinEnter', 'TermOpen', 'FileType'}, {
        pattern = '*',
        callback = function()
          local ok = vim.bo.buftype == "" and not nocolumn[vim.bo.filetype]
          vim.wo.colorcolumn = ok and "120" or ""
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

      vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
        pattern = '*.slim',
        callback = function()
          vim.bo.filetype = 'slim'
        end,
      })
    '';
  };
}
