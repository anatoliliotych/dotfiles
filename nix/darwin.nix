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
  # the machine on AC; nix-darwin has no typed option for it.  -c scopes
  # to charger only; || true guards the whole activation (set -e) against
  # pmset failing on hardware that lacks the powernap key.
  system.activationScripts.extraActivation.text = ''
    pmset -c powernap 0 || true
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

  # Keyboard layer: symbolic hotkeys and input sources declared as
  # structured values (nix-darwin writes them into the user's domain).
  # parameters = (keyCode, charCode, modifiers); modifiers: 262144=Ctrl,
  # 524288=Option, 1048576=Cmd, 8388608=Fn; 65535 = unbound.
  system.defaults.CustomUserPreferences."com.apple.symbolichotkeys" = {
    AppleSymbolicHotKeys = {
      # F1-F12 accessibility keys off
      "15" = {
        enabled = false;
      };
      "16" = {
        enabled = false;
      };
      "17" = {
        enabled = false;
      };
      "18" = {
        enabled = false;
      };
      "19" = {
        enabled = false;
      };
      "20" = {
        enabled = false;
      };
      "21" = {
        enabled = false;
      };
      "22" = {
        enabled = false;
      };
      "23" = {
        enabled = false;
      };
      "24" = {
        enabled = false;
      };
      "25" = {
        enabled = false;
      };
      "26" = {
        enabled = false;
      };

      # Select the previous input source: Option+Space (macOS default)
      "60" = {
        enabled = true;
        value = {
          parameters = [
            32
            49
            524288
          ];
          type = "standard";
        };
      };
      # Select next source in Input menu (disabled)
      "61" = {
        enabled = false;
        value = {
          parameters = [
            32
            49
            1179648
          ];
          type = "standard";
        };
      };

      # Move to previous/next space (enabled with default bindings;
      # 80/82 are the slow double-press variants)
      "79" = {
        enabled = true;
      };
      "80" = {
        enabled = true;
      };
      "81" = {
        enabled = true;
      };
      "82" = {
        enabled = true;
      };

      # Legacy hotkey, unbound
      "164" = {
        enabled = false;
        value = {
          parameters = [
            65535
            65535
            0
          ];
          type = "standard";
        };
      };
      # Legacy AppleScript action, disabled
      "176" = {
        enabled = false;
        value = {
          type = "SAE1.0";
        };
      };

      # Minimize: Cmd+F10
      "233" = {
        enabled = true;
        value = {
          parameters = [
            109
            46
            1048576
          ];
          type = "standard";
        };
      };
      # Zoom (window management, disabled): Cmd+Shift+F10
      "235" = {
        enabled = false;
        value = {
          parameters = [
            109
            46
            1179648
          ];
          type = "standard";
        };
      };
      # Fill: Fn+Ctrl+F
      "237" = {
        enabled = true;
        value = {
          parameters = [
            102
            3
            8650752
          ];
          type = "standard";
        };
      };
      # Center: Fn+Ctrl+C
      "238" = {
        enabled = true;
        value = {
          parameters = [
            99
            8
            8650752
          ];
          type = "standard";
        };
      };
      # Return to Previous Size: Fn+Ctrl+R
      "239" = {
        enabled = true;
        value = {
          parameters = [
            114
            15
            8650752
          ];
          type = "standard";
        };
      };
    };
  };

  # Input sources: U.S. + Russian layouts with the standard IMs.
  system.defaults.CustomUserPreferences."com.apple.HIToolbox" = {
    AppleEnabledInputSources = [
      {
        InputSourceKind = "Keyboard Layout";
        "KeyboardLayout ID" = 0;
        "KeyboardLayout Name" = "U.S.";
      }
      {
        "Bundle ID" = "com.apple.CharacterPaletteIM";
        InputSourceKind = "Non Keyboard Input Method";
      }
      {
        "Bundle ID" = "com.apple.PressAndHold";
        InputSourceKind = "Non Keyboard Input Method";
      }
      {
        InputSourceKind = "Keyboard Layout";
        "KeyboardLayout ID" = 19456;
        "KeyboardLayout Name" = "Russian";
      }
      {
        "Bundle ID" = "com.apple.inputmethod.ironwood";
        InputSourceKind = "Non Keyboard Input Method";
      }
    ];
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
