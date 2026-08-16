{ ... }:

{
  programs.aerospace = {
    enable = true;
    launchd = {
      enable = true;
    };
    settings = {
      after-startup-command = [
        ''exec-and-forget open -a "Zen"''
        ''exec-and-forget open -a "Safari"''
        ''exec-and-forget open -a "WezTerm"''
        ''exec-and-forget open -a "Mail"''
        ''exec-and-forget open -a "Calendar"''
        ''exec-and-forget open -a "Telegram"''
        ''exec-and-forget open -a "Beeper Desktop"''
      ];

      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      accordion-padding = 30;

      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";

      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

      automatically-unhide-macos-hidden-apps = false;

      key-mapping = {
        preset = "qwerty";
      };

      workspace-to-monitor-force-assignment = {
        "1" = "Benq RD280U";
      };

      gaps = {
        inner.horizontal = 10;
        inner.vertical = 10;
        outer.left = 10;
        outer.bottom = 10;
        outer.top = 10;
        outer.right = 10;
      };

      mode.main.binding = {
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";

        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        alt-minus = "resize smart -50";
        alt-equal = "resize smart +50";

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-b = "workspace B";
        alt-c = "workspace C";
        alt-m = "workspace M";
        alt-o = "workspace O";
        alt-t = "workspace T";

        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-b = "move-node-to-workspace B";
        alt-shift-c = "move-node-to-workspace C";
        alt-shift-m = "move-node-to-workspace M";
        alt-shift-o = "move-node-to-workspace O";
        alt-shift-t = "move-node-to-workspace T";

        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        alt-shift-semicolon = "mode service";
      };

      on-window-detected = [
        {
          "if".app-id = "com.apple.mail";
          run = "move-node-to-workspace C";
          check-further-callbacks = false;
        }
        {
          "if".app-id = "com.apple.iCal";
          run = [ "move-node-to-workspace C" ];
          check-further-callbacks = false;
        }
        {
          "if".app-id = "com.automattic.beeper.desktop";
          run = "move-node-to-workspace M";
          check-further-callbacks = false;
        }
        {
          "if".app-id = "ru.keepcoder.Telegram";
          run = "move-node-to-workspace M";
          check-further-callbacks = false;
        }
        {
          "if".app-id = "com.github.wez.wezterm";
          run = "move-node-to-workspace T";
          check-further-callbacks = false;
        }
        {
          "if".app-id = "com.apple.finder";
          run = [ "layout floating" ];
          check-further-callbacks = false;
        }
      ];

      mode.service.binding = {
        esc = [
          "reload-config"
          "mode main"
        ];
        r = [
          "flatten-workspace-tree"
          "mode main"
        ];
        f = [
          "layout floating tiling"
          "mode main"
        ];
        backspace = [
          "close-all-windows-but-current"
          "mode main"
        ];

        alt-shift-h = [
          "join-with left"
          "mode main"
        ];
        alt-shift-j = [
          "join-with down"
          "mode main"
        ];
        alt-shift-k = [
          "join-with up"
          "mode main"
        ];
        alt-shift-l = [
          "join-with right"
          "mode main"
        ];

        down = "volume down";
        up = "volume up";
        shift-down = [
          "volume set 0"
          "mode main"
        ];
      };
    };
  };
}
