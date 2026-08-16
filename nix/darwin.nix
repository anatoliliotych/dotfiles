{
  pkgs,
  nix-darwin,
  user,
  ...
}:

{
  nix.enable = false;

  launchd.daemons.nix-gc = {
    command = "${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 14d";
    serviceConfig = {
      RunAtLoad = false;
      StartCalendarInterval = [
        {
          Weekday = 0;
          Hour = 10;
          Minute = 0;
        }
      ];
    };
  };
  launchd.daemons.nix-optimise = {
    command = "${pkgs.nix}/bin/nix-store --optimise";
    serviceConfig = {
      RunAtLoad = false;
      StartCalendarInterval = [
        {
          Weekday = 0;
          Hour = 10;
          Minute = 30;
        }
      ];
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.primaryUser = user;

  system.defaults.dock = {
    tilesize = 47;
    autohide = true;
    show-recents = false;
    # Hot corners: 13 = Lock Screen, 1 = Disabled
    wvous-tr-corner = 13;
    wvous-br-corner = 1;
  };

  # The Cmd modifier on the top-right corner (nix-darwin has no typed
  # option for hot corner modifiers).
  system.defaults.CustomUserPreferences."com.apple.dock" = {
    "wvous-tr-modifier" = 1048576;
  };

  system.defaults.trackpad = {
    Clicking = true;
    TrackpadThreeFingerDrag = true;
  };

  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";

  system.defaults.finder = {
    ShowPathbar = true;
    ShowStatusBar = true;
  };

  services.tailscale.enable = true;

  users.users.${user}.home = "/Users/${user}";

  environment.systemPackages = [
    nix-darwin.packages.${pkgs.stdenv.hostPlatform.system}.darwin-rebuild
  ];

  system.stateVersion = 6;
}
