{
  gitName,
  gitEmail,
  ...
}:

{
  programs.git = {
    enable = true;
    ignores = [
      "**/.claude/settings.local.json"
    ];
    settings = {
      init = {
        defaultBranch = "main";
      };
      user = {
        name = gitName;
        email = gitEmail;
      };
      fetch = {
        prune = true;
      };
      rerere = {
        enabled = true;
      };
      merge = {
        conflictStyle = "zdiff3";
      };
      diff = {
        algorithm = "histogram";
      };
    };
  };
}
