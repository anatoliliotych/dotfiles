{ config, pkgs, lib, ... }:

{
  home.username = "al";
  home.homeDirectory = "/Users/al";
  home.stateVersion = "24.11";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home.packages = with pkgs; [
    autojump
    bat
    claude-code
    curl
    direnv
    fzf
    git
    htop
    llama-cpp
    neovim
    ripgrep
    (python312.withPackages (ps: with ps; [ httpx requests ]))
    tmux
    zsh
    zsh-fzf-tab
  ];

  home.activation.installNeoVimVimPlug = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=$PATH:${pkgs.git}/bin:${pkgs.curl}/bin
    mkdir -p "$HOME/.config/nvim/autoload"
    mkdir -p "$HOME/.config/nvim/plugged"

    if [ ! -f "$HOME/.config/nvim/autoload/plug.vim" ]; then
      echo "Installing vim-plug..."
      ${pkgs.curl}/bin/curl -fLo "$HOME/.config/nvim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

    echo "Installing/updating vim plugins..."
    ${pkgs.neovim}/bin/nvim -u ~/.config/nvim/setup.lua --headless +PlugInstall +PlugUpdate +qall
  '';

  programs.home-manager.enable = true;
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  programs.fzf = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
  };

  programs.zsh = {
    initContent = ''
      eval "$(direnv hook zsh)"
      remind() {
        osascript -e "tell application \"Reminders\" to make new reminder in list \"Backlog\" with properties {name:\"$*\"}"
      }

      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';
    enable = true;
    syntaxHighlighting = {
      enable = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "vi-mode" "autojump"];
      theme = "onehalfdark";
      custom = "$HOME/.config/oh-my-zsh";
    };

    shellAliases = {
      copilot="llama-server -m /Users/al/models/Qwen_2.5_Coder_3B.gguf --port 8012 -ngl 99 -fa -ub 1024 -b 1024 --ctx-size 0 --cache-reuse 256 --log-disable";
      vim="nvim";
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
    userName = "Anatoli Liotych";
    userEmail = "anatoli.liotych@gmail.com";
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.file.".config/oh-my-zsh/themes/onehalfdark.zsh-theme".source = ~/dotfiles/onehalfdark.zsh-theme;
  home.file.".config/nvim/init.lua".source = ~/dotfiles/nvim/init.lua;
  home.file.".config/nvim/setup.lua".source = ~/dotfiles/nvim/setup.lua;
  home.file.".config/nvim/lua/autocmd.lua".source = ~/dotfiles/nvim/lua/autocmd.lua;
  home.file.".config/nvim/lua/settings.lua".source = ~/dotfiles/nvim/lua/settings.lua;
  home.file.".config/nvim/lua/plugins.lua".source = ~/dotfiles/nvim/lua/plugins.lua;
  home.file.".wezterm.lua".source = ~/dotfiles/.wezterm.lua;
  home.file.".tmux.conf".source = ~/dotfiles/.tmux.conf;
}
