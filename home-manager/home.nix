{ config, pkgs, lib, dotfiles, ... }:

let
  opensuperwhisper-app = pkgs.callPackage ./opensuperwhisper.nix {};

  # vim-plug plugins provided by nix instead of git clones. vim-plug sees the
  # dirs in plugged/ and skips cloning, so the Plug lines in dotfiles/nvim stay
  # untouched. Versions follow the nixpkgs pin: update via `nix flake update`
  # + switch. Treesitter parsers are still refreshed per switch via TSUpdate.
  nvimPlugged = pkgs.runCommand "nvim-plugged" { } ''
    mkdir -p $out/onehalf
    ln -s ${pkgs.vimPlugins.vim-airline} $out/vim-airline
    ln -s ${pkgs.vimPlugins.vim-gitgutter} $out/vim-gitgutter
    ln -s ${pkgs.vimPlugins.llama-vim} $out/llama.vim
    ln -s ${pkgs.vimPlugins.fzf-lua} $out/fzf-lua
    ln -s ${pkgs.vimPlugins.nvim-treesitter} $out/nvim-treesitter
    ln -s ${pkgs.vimPlugins.indent-blankline-nvim} $out/indent-blankline.nvim
    ln -s ${pkgs.vimPlugins.which-key-nvim} $out/which-key.nvim
    ln -s ${pkgs.vimPlugins.vim-fugitive} $out/vim-fugitive
    # nixpkgs flattens the repo; wrap in vim/ to match `rtp = 'vim'`.
    ln -s ${pkgs.vimPlugins.onehalf} $out/onehalf/vim
  '';
in
{
  home.username = "al";
  home.homeDirectory = "/Users/al";
  home.stateVersion = "26.05";

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home.packages = with pkgs; [
    _1password-cli
    aerospace
    opensuperwhisper-app
    autojump
    eza
    gh
    nodejs
    curl
    htop
    llm-agents.claude-code
    llama-cpp
    neovim
    ripgrep
    (python313.withPackages (ps: with ps; [ httpx requests ]))
    tmux
    tree-sitter
  ];

  home.activation.updateTreesitterParsers = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=$PATH:${pkgs.git}/bin:${pkgs.curl}/bin:${pkgs.tree-sitter}/bin
    echo "Updating treesitter parsers..."
    ${pkgs.neovim}/bin/nvim -u ~/.config/nvim/init.lua --headless +TSUpdate +qall
  '';

  launchd.agents.opensuperwhisper = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/open"
        "${config.home.homeDirectory}/Applications/Home Manager Apps/OpenSuperWhisper.app"
      ];
      RunAtLoad = true;
      KeepAlive = false;
      LimitLoadToSessionType = "Aqua";
      ProcessType = "Interactive";
    };
  };

  programs.home-manager = {
    enable = true;
  };

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  programs.fzf = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
  };

  programs.zsh = {
    initContent = ''
      # ANTHROPIC_AUTH_TOKEN comes from 1Password. Item: "DeepSeek API" in the
      # Personal vault (API Credential). Non-secret ANTHROPIC_* config lives in
      # ~/.claude/settings.json "env".
      if token="$(op read 'op://Personal/DeepSeek API/credential' 2>/dev/null)"; then
        export ANTHROPIC_AUTH_TOKEN="$token"
      fi
    '';
    plugins = [
      { name = "fzf-tab"; src = pkgs.zsh-fzf-tab; file = "share/fzf-tab/fzf-tab.plugin.zsh"; }
    ];
    enable = true;
    syntaxHighlighting = {
      enable = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "vi-mode" "autojump"];
      theme = "onehalfdark";
      custom = "${config.home.homeDirectory}/.config/oh-my-zsh";
    };

    shellAliases = {
      # Detached tmux session "bg": window 1 runs the copilot llama-server,
      # window 2 runs caffeinate -d. Idempotent; attach with `tmux attach -t bg`.
      tm="tmux has-session -t bg 2>/dev/null || (tmux new-session -d -s bg -n copilot llama-server --fim-qwen-3b-default && tmux new-window -t bg -n caffeinate 'caffeinate -d')";
      vim="nvim";
      ls="eza --icons --grid  --group-directories-first";
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "OneHalfDark";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Anatoli Liotych";
        email = "anatoli.liotych@gmail.com";
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file.".config/oh-my-zsh/themes/onehalfdark.zsh-theme".source = "${dotfiles}/onehalfdark.zsh-theme";
  home.file.".config/nvim".source = "${dotfiles}/nvim";
  home.file.".config/nvim".recursive = true;
  home.file.".config/nvim/plugged".source = nvimPlugged;
  # vim-plug itself from nixpkgs - no curl bootstrap needed.
  home.file.".config/nvim/autoload/plug.vim".source = "${pkgs.vimPlugins.vim-plug}/plug.vim";
  home.file.".tmux.conf".source = "${dotfiles}/.tmux.conf";
  home.file.".aerospace.toml".source = "${dotfiles}/.aerospace.toml";
  home.file.".wezterm.lua".source = "${dotfiles}/.wezterm.lua";
  home.file."AGENTS.md".source = "${dotfiles}/AGENTS.md";
}
