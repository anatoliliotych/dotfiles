{
  gitName,
  gitEmail,
  ...
}:

{
  programs.git = {
    enable = true;
    settings = {
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
