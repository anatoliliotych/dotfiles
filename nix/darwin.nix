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
          Hour = 2;
          Minute = 30;
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
          Hour = 3;
          Minute = 0;
        }
      ];
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  services.tailscale.enable = true;

  users.users.${user}.home = "/Users/${user}";

  environment.systemPackages = [
    nix-darwin.packages.${pkgs.stdenv.hostPlatform.system}.darwin-rebuild
  ];

  system.stateVersion = 6;
}
