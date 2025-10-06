{ config, pkgs, lib, ... }:

{
  home.username = "al";
  home.homeDirectory = "/Users/al";
  home.stateVersion = "25.05";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home.packages = with pkgs; [
    aerospace
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
      export PATH="$PATH:/Applications/AeroSpace.app/Contents/MacOS"
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
      copilot="llama-server --fim-qwen-3b-default";
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
    EDITOR = "nvim";
  };

  home.file.".config/oh-my-zsh/themes/onehalfdark.zsh-theme".source = ~/dotfiles/onehalfdark.zsh-theme;
  home.file.".config/nvim".source = ~/dotfiles/nvim;
  home.file.".config/nvim".recursive = true;
  home.file.".tmux.conf".source = ~/dotfiles/.tmux.conf;
  home.file.".aerospace.toml".source = ~/dotfiles/.aerospace.toml;
}
