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

  launchd.agents.llama-log-rotate = {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "log=\"$HOME/Library/Logs/llama-server.log\"; if [ -f \"$log\" ]; then mv \"$log\" \"$log.1\"; launchctl kickstart -k gui/$(id -u)/org.nix-community.home.llama-server; fi"
      ];
      RunAtLoad = false;
      StartCalendarInterval = [
        {
          Weekday = 0;
          Hour = 3;
          Minute = 30;
        }
      ];
    };
  };
}
