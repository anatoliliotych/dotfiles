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
    plugins = [ tmux-onehalf ];
    extraConfig = ''
      # Set default terminal and enable 256 colors
      set -g default-terminal "screen-256color"
      set -as terminal-features ",xterm-256color:RGB"

      set -g status-justify centre
      # Enable xterm keys
      setw -g xterm-keys on

      # Reduce escape time for faster response
      set -s escape-time 0

      # Increase history limit
      set-option -g history-limit 1000000

      # Enable clipboard integration
      set -g set-clipboard on

      # Start window numbering at 1
      set -g base-index 1

      # Enable aggressive window resizing
      setw -g aggressive-resize on

      # Status bar configuration
      set -g status-fg white
      set -g status-bg default
      set -g status-style bright
      set -g status-right '#H'

      # Window status styling
      set-window-option -g window-status-style fg=white
      set-window-option -g window-status-style bg=default
      set-window-option -g window-status-style dim

      # Active window styling
      set-window-option -g window-status-current-style fg=white
      set-window-option -g window-status-current-style bg=default
      set-window-option -g window-status-current-style bright
      set-window-option -g window-status-current-style bg=red

      # Monitor window activity
      setw -g monitor-activity on
      set -g visual-activity on

      # Enable automatic window renaming
      set-window-option -g automatic-rename on

      # Enable vi mode for copy/paste
      set-window-option -g mode-keys vi

      # Configuration reload
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded..."

      # Clear screen and history
      bind-key -n C-k send-keys 'clear' Enter \; clear-history

      # Window management
      bind t new-window -c "#{pane_current_path}"

      # Pane splitting (intuitive keys)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Pane navigation (vim-like)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Pane synchronization
      bind e setw synchronize-panes on
      bind E setw synchronize-panes off

      # Rebind prefix
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix
    '';
  };
}
