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
      theme = "OneHalfDark";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file."AGENTS.md".source = "${dotfiles}/AGENTS.md";
  # Claude Code loads ~/.claude/CLAUDE.md as global instructions; link it
  # to the same AGENTS.md so both stay in sync.
  home.file.".claude/CLAUDE.md".source = "${dotfiles}/AGENTS.md";
}
