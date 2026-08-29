{
  config,
  pkgs,
  dotfiles,
  tuicr,
  user,
  ...
}:

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    _1password-cli
    autojump
    devenv
    eza
    fzf
    gh
    htop
    jq
    llm-agents.claude-code
    llama-cpp
    ripgrep
    rtk
    tmux
    tree-sitter
    tuicr
    wezterm
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Frappe";
    };
  };

  home.file.".config/bat/themes/Catppuccin Frappe.tmTheme".source =
    "${pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "bat";
      rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
      hash = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
    }}/themes/Catppuccin Frappe.tmTheme";

  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = false; # no sync, ever - local history only
      update_check = false; # nix manages versions
      invert = true; # search prompt at top instead of bottom
      show_help = true; # show keybinding help line
      auto_hide_height = 0; # never hide the help/tabs row in compact mode
      theme.name = "catppuccin-frappe-blue"; # default theme's hint-row color
      # (dark grey) is unreadable on dark backgrounds; see the theme file
      # below - blue accent, matching the blue accent used across
      # tmux/nvim/fzf-tab
    };
  };

  # Catppuccin Frappe (blue accent) for atuin, from catppuccin/atuin's own
  # theme (exact hex values, not guessed), trimmed to the Meanings that
  # exist in the pinned atuin version (18.15.2) - it predates the Syntax*
  # meanings, and an unknown key fails the whole theme's deserialization,
  # silently dropping atuin to unstyled.
  home.file.".config/atuin/themes/catppuccin-frappe-blue.toml".text = ''
    [theme]
    name = "catppuccin-frappe-blue"

    [colors]
    AlertInfo = "#a6d189"
    AlertWarn = "#ef9f76"
    AlertError = "#e78284"
    Annotation = "#8caaee"
    Base = "#c6d0f5"
    Guidance = "#949cbb"
    Important = "#e78284"
    Title = "#8caaee"
    Muted = "#737994"
  '';

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file."AGENTS.md".source = "${dotfiles}/AGENTS.md";
  # Claude Code loads ~/.claude/CLAUDE.md as global instructions; link it
  # to the same AGENTS.md so both stay in sync.
  home.file.".claude/CLAUDE.md".source = "${dotfiles}/AGENTS.md";
}
