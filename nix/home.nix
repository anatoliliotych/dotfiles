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
    eza
    fzf
    gh
    nodejs
    htop
    llm-agents.claude-code
    llama-cpp
    ripgrep
    (python313.withPackages (
      ps: with ps; [
        httpx
      ]
    ))
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
}
