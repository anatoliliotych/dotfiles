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
    curl
    direnv
    fzf
    git
    htop
    llama-cpp
    claude-code
    ripgrep
    (python312.withPackages (ps: with ps; [ httpx requests ]))
    vim-full
    wl-clipboard
    zsh
    zsh-fzf-tab
  ];

  home.activation.installVimPlug = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=$PATH:${pkgs.git}/bin:${pkgs.curl}/bin
    mkdir -p "$HOME/.vim/autoload"
    mkdir -p "$HOME/.vim/plugged"

    if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
      echo "Installing vim-plug..."
      ${pkgs.curl}/bin/curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

    echo "Installing/updating vim plugins..."
    ${pkgs.vim-full}/bin/vim +PlugInstall +PlugUpdate +qall
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
      if command -v rg &> /dev/null; then
        export FZF_DEFAULT_COMMAND='rg --files'
        export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border --margin=1,4'
      fi
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
      plugins = [ "git" "vi-mode" "autojump" ];
      theme = "onehalfdark";
      custom = "$HOME/.oh-my-zsh";
    };
    shellAliases = {
      copilot="llama-server -m /Users/al/models/Qwen_2.5_Coder_3B.gguf --port 8012 -ngl 99 -fa -ub 1024 -b 1024 --ctx-size 0 --cache-reuse 256 --log-disable";
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

  home.file.".oh-my-zsh/themes/onehalfdark.zsh-theme".source = ~/dotfiles/onehalfdark.zsh-theme;
  home.file.".vimrc".source = ~/dotfiles/.vimrc;
}
