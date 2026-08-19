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
  # Reattach to the GUI session so Touch ID also works inside tmux
  security.pam.services.sudo_local.reattach = true;

  # Power Nap's maintenance sleep ignores caffeinate and repeatedly sleeps
  # the machine on AC; nix-darwin has no typed option for it.
  system.activationScripts.extraActivation.text = ''
    pmset -a powernap 0
    # macOS keyboard layer: custom symbolic hotkeys (Ctrl+U previous input
    # source, Cmd+F10 minimize, unbound space-moves), US+Russian input
    # sources, and per-keyboard CapsLock-as-Globe mappings.
    defaults import com.apple.symbolichotkeys ${./darwin/com.apple.symbolichotkeys.plist}
    defaults import com.apple.HIToolbox ${./darwin/com.apple.HIToolbox.plist}
    defaults -currentHost write NSGlobalDomain "com.apple.keyboard.modifiermapping.0-0-0" -array '<dict><key>HIDKeyboardModifierMappingSrc</key><integer>30064771129</integer><key>HIDKeyboardModifierMappingDst</key><integer>1095216660483</integer></dict>'
    defaults -currentHost write NSGlobalDomain "com.apple.keyboard.modifiermapping.4176-1031-0" -array '<dict><key>HIDKeyboardModifierMappingSrc</key><integer>30064771129</integer><key>HIDKeyboardModifierMappingDst</key><integer>30064771072</integer></dict>'
    defaults -currentHost write NSGlobalDomain "com.apple.keyboard.modifiermapping.7504-24926-0" -array '<dict><key>HIDKeyboardModifierMappingSrc</key><integer>30064771129</integer><key>HIDKeyboardModifierMappingDst</key><integer>1095216660483</integer></dict>'
  '';

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
