{ config, pkgs, lib, dotfiles, ... }:

let
  opensuperwhisper-app = pkgs.callPackage ./opensuperwhisper.nix {};
in
{
  home.username = "al";
  home.homeDirectory = "/Users/al";
  home.stateVersion = "26.05";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home.packages = with pkgs; [
    _1password-cli
    aerospace
    opensuperwhisper-app
    autojump
    bat
    eza
    git
    gh
    fzf
    nodejs
    curl
    htop
    llm-agents.claude-code
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
    ${pkgs.neovim}/bin/nvim -u ~/.config/nvim/init.lua --headless +PlugInstall +PlugUpdate +TSUpdate +qall
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
      substituters = [ "https://cache.nixos.org/" ];
    };
  };

  programs.fzf = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    package = pkgs.direnv.overrideAttrs (oldAttrs: {
      doCheck = false;
    });
  };

  programs.zsh = {
    initContent = ''
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      # ANTHROPIC_AUTH_TOKEN comes from 1Password. Item: "DeepSeek API" in the
      # Private vault (API Credential). Non-secret ANTHROPIC_* config lives in
      # ~/.claude/settings.json "env".
      if token="$(op read 'op://Personal/DeepSeek API/credential' 2>/dev/null)"; then
        export ANTHROPIC_AUTH_TOKEN="$token"
      fi
    '';
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
      # Flake evaluation is always pure, so the self-updating OpenSuperWhisper
      # fetch (hashless builtins.fetchurl) needs --impure on every invocation.
      "home-manager"="home-manager --impure";
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
  home.file.".tmux.conf".source = "${dotfiles}/.tmux.conf";
  home.file.".aerospace.toml".source = "${dotfiles}/.aerospace.toml";
  home.file.".wezterm.lua".source = "${dotfiles}/.wezterm.lua";
  home.file."AGENTS.md".source = "${dotfiles}/AGENTS.md";
}
