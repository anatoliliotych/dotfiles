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
    aerospace
    autojump
    eza
    gh
    nodejs
    htop
    llm-agents.claude-code
    llama-cpp
    ripgrep
    (python313.withPackages (
      ps: with ps; [
        httpx
        requests
      ]
    ))
    tmux
    tree-sitter
    tuicr
    wezterm
  ];

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  programs.fzf = {
    enable = true;
  };

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

  home.file.".config/oh-my-zsh/themes/onehalfdark.zsh-theme".source =
    "${dotfiles}/configs/onehalfdark.zsh-theme";
  home.file.".aerospace.toml".source = "${dotfiles}/configs/.aerospace.toml";
  home.file.".wezterm.lua".source = "${dotfiles}/configs/.wezterm.lua";
  home.file."AGENTS.md".source = "${dotfiles}/AGENTS.md";
}
