{ pkgs, nix-darwin, ... }:

{
  # Tiny system-level config: everything user-level lives in ./home.nix and
  # ./nvim.nix. Keep this file small on purpose.

  # Determinate Systems nix-installer owns the nix daemon and
  # /etc/nix/nix.conf (see /Library/LaunchDaemons/systems.determinate.*), so
  # nix-darwin must not manage nix (nix.gc / nix.optimise require nix.enable
  # and would conflict). Store maintenance runs as plain launchd daemons
  # below against the existing daemon instead.
  nix.enable = false;

  # Weekly store maintenance: garbage-collect anything older than 14 days,
  # then hardlink-duplicate store files.
  launchd.daemons.nix-gc = {
    command = "${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 14d";
    serviceConfig = {
      RunAtLoad = false;
      StartCalendarInterval = [ { Weekday = 0; Hour = 2; Minute = 30; } ];
    };
  };
  launchd.daemons.nix-optimise = {
    command = "${pkgs.nix}/bin/nix-store --optimise";
    serviceConfig = {
      RunAtLoad = false;
      StartCalendarInterval = [ { Weekday = 0; Hour = 3; Minute = 0; } ];
    };
  };

  # sudo with Touch ID
  security.pam.services.sudo_local.touchIdAuth = true;

  # Required by the home-manager integration: it reads the user's home from
  # here. The account itself already exists; nix-darwin does not create it.
  users.users.al = {
    name = "al";
    home = "/Users/al";
  };

  environment.systemPackages = [
    nix-darwin.packages.${pkgs.system}.darwin-rebuild
  ];

  system.stateVersion = 6;
}
