{ config, pkgs, lib, dotfiles, ... }:

let
  opensuperwhisper-app = pkgs.callPackage ./opensuperwhisper.nix {};
  mole = pkgs.callPackage ./mole.nix {};
in
{
  home.username = "al";
  home.homeDirectory = "/Users/al";
  home.stateVersion = "26.05";

  # allowUnfree is set on the pkgs built in flake.nix.

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

  # OpenSuperWhisper installs at a stable ~/Applications path instead of the
  # hm-managed symlink into the nix store: macOS invalidates TCC grants when
  # the app's real path changes, and a store path changes on every repackage.
  # A fixed path with in-place replacement keeps Input Monitoring and
  # Accessibility grants across updates. See opensuperwhisper.nix.
  # The marker lives OUTSIDE the bundle: the bundle must stay byte-identical
  # to the store copy (it is signed + notarized), and store copies are
  # read-only, so nothing can be written inside it anyway.
  home.activation.installOpenSuperWhisper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    src="${opensuperwhisper-app}/Applications/OpenSuperWhisper.app"
    dst="$HOME/Applications/OpenSuperWhisper.app"
    marker="$HOME/Applications/.opensuperwhisper.nix-source"
    if [[ ! -e "$dst" ]] || [[ "$(cat "$marker" 2>/dev/null)" != "${opensuperwhisper-app}" ]]; then
      rm -rf "$dst.new"
      cp -R "$src" "$dst.new"
      rm -rf "$dst"
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

  # Autostart the window manager at login. Same pattern as opensuperwhisper:
  # open launches the app once; KeepAlive stays off to avoid relaunch loops.
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

  # No programs.home-manager here: home-manager is activated by nix-darwin
  # (darwin-rebuild switch). The hm nix module below only writes user-level
  # nix.conf; system nix config is owned by the Determinate installer.

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
  home.file.".tmux.conf".source = "${dotfiles}/.tmux.conf";
  home.file.".aerospace.toml".source = "${dotfiles}/.aerospace.toml";
  home.file.".wezterm.lua".source = "${dotfiles}/.wezterm.lua";
  home.file."AGENTS.md".source = "${dotfiles}/AGENTS.md";
}
