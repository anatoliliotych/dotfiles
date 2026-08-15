{ config, pkgs, lib, dotfiles, ... }:

let
  opensuperwhisper-app = pkgs.callPackage ./opensuperwhisper.nix {};
  mole = pkgs.callPackage ./mole.nix {};
in
{
  home.username = "al";
  home.homeDirectory = "/Users/al";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    _1password-cli
    aerospace
    autojump
    eza
    gh
    nodejs
    curl
    htop
    llm-agents.claude-code
    llama-cpp
    mole
    ripgrep
    (python313.withPackages (ps: with ps; [ httpx requests ]))
    tmux
    tree-sitter
    wezterm
  ];

  home.activation.installOpenSuperWhisper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    src="${opensuperwhisper-app}/Applications/OpenSuperWhisper.app"
    dst="$HOME/Applications/OpenSuperWhisper.app"
    marker="$HOME/Applications/.opensuperwhisper.nix-source"
    if [[ ! -e "$dst" ]] || [[ "$(cat "$marker" 2>/dev/null)" != "${opensuperwhisper-app}" ]]; then
      # Store copies are read-only, so make leftovers deletable before
      # removing them and keep the fresh copy writable too.
      chmod -R u+w "$dst.new" 2>/dev/null || true
      rm -rf "$dst.new"
      chmod -R u+w "$dst" 2>/dev/null || true
      rm -rf "$dst"
      cp -R "$src" "$dst.new"
      chmod -R u+w "$dst.new"
      mv "$dst.new" "$dst"
      printf '%s' "${opensuperwhisper-app}" > "$marker"
    fi
  '';

  launchd.agents.opensuperwhisper = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/open"
        "${config.home.homeDirectory}/Applications/OpenSuperWhisper.app"
      ];
      RunAtLoad = true;
      KeepAlive = false;
      LimitLoadToSessionType = "Aqua";
      ProcessType = "Interactive";
    };
  };

  launchd.agents.aerospace = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/open"
        "${config.home.homeDirectory}/Applications/Home Manager Apps/AeroSpace.app"
      ];
      RunAtLoad = true;
      KeepAlive = false;
      LimitLoadToSessionType = "Aqua";
      ProcessType = "Interactive";
    };
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
  home.file.".tmux.conf".source = "${dotfiles}/.tmux.conf";
  home.file.".aerospace.toml".source = "${dotfiles}/.aerospace.toml";
  home.file.".wezterm.lua".source = "${dotfiles}/.wezterm.lua";
  home.file."AGENTS.md".source = "${dotfiles}/AGENTS.md";
}
