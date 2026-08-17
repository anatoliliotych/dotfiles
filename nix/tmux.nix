{ pkgs, ... }:

let
  tmux-onehalf = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-onehalf-theme";
    version = "unstable-2026-08-16";
    rtpFilePath = "main.tmux";

    src = pkgs.fetchFromGitHub {
      owner = "andersondanilo";
      repo = "tmux-onehalf-theme";
      rev = "1a099d775c948bc1b72c16c05aca5fb2f1bd3c03";
      hash = "sha256-ExUJc14niGSNzqX3e1GjxZMv0y4gLmzfoQG0hzRFI5s=";
    };

    meta = {
      description = "OneHalf color theme for tmux (dark variant)";
      homepage = "https://github.com/andersondanilo/tmux-onehalf-theme";
      license = pkgs.lib.licenses.mit;
      platforms = pkgs.lib.platforms.unix;
    };
  };
in
{
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    baseIndex = 1;
    escapeTime = 0;
    plugins = [
      tmux-onehalf
      pkgs.tmuxPlugins.cpu
      pkgs.tmuxPlugins.yank
      {
        plugin = pkgs.tmuxPlugins.resurrect;
        extraConfig = ''
          # Plain-tap save/restore: C-s does not chord on the Corne's
          # home-row mods, and chords after a prefix are slow anyway.
          set -g @resurrect-save 's'
          set -g @resurrect-restore 'r'
        '';
      }
      pkgs.tmuxPlugins.continuum
      {
        plugin = pkgs.tmuxPlugins.tmux-thumbs;
        extraConfig = ''
          # Space is taken by the native list-keys popup; thumbs moves
          # to prefix + g (home row, free in the prefix table).
          set -g @thumbs-key g
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.tmux-fzf;
        extraConfig = ''
          # Launch on plain f (Shift+F is a cross-hand chord on the Corne)
          set-environment -g TMUX_FZF_LAUNCH_KEY f
        '';
      }
      pkgs.tmuxPlugins.fzf-tmux-url
    ];
    extraConfig = ''
      # Auto-restore saved sessions when tmux starts (continuum + resurrect)
      set -g @continuum-restore 'on'

      # Enable 256 colors
      set -as terminal-features ",xterm-256color:RGB"

      set -g status-justify centre
      # Enable xterm keys
      setw -g xterm-keys on

      # Increase history limit
      set-option -g history-limit 1000000

      # Enable clipboard integration
      set -g set-clipboard on

      # Enable aggressive window resizing
      setw -g aggressive-resize on

      # Monitor window activity
      setw -g monitor-activity on
      set -g visual-activity on

      # Enable automatic window renaming
      set-window-option -g automatic-rename on

      # Enable vi mode for copy/paste
      set-window-option -g mode-keys vi

      # Configuration reload
      bind a source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded..."

      # Clear screen and history
      bind-key -n C-k send-keys 'clear' Enter \; clear-history

      # Window management
      bind t new-window -c "#{pane_current_path}"

      # Pane splitting (plain taps; % and " are 400ms symbol holds on the Corne)
      bind v split-window -h -c "#{pane_current_path}"
      bind b split-window -v -c "#{pane_current_path}"
      unbind %
      unbind '"'

      # Pane navigation (vim-like)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Pane synchronization (toggle)
      bind e setw synchronize-panes

      # Keybinding discovery: native list-keys popup, always accurate
      # (replaces next-layout, which was the default Space binding)
      bind Space list-keys -N -T prefix

      # Drop uppercase defaults (shift chords do not fit the Corne)
      unbind D
      unbind M

      # Rebind prefix to C-Space (hold A + tap Space, one hand)
      unbind C-b
      set-option -g prefix C-Space
      bind-key C-Space send-prefix
    '';
  };
}
