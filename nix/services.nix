{
  config,
  pkgs,
  ...
}:

{
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

  launchd.agents.llama-server = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.llama-cpp}/bin/llama-server"
        "--fim-qwen-3b-default"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/llama-server.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/llama-server.log";
    };
  };

  launchd.agents.caffeinate = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/caffeinate"
        "-d"
      ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}
