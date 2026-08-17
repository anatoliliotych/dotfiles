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
      pkgs.tmuxPlugins.resurrect
      pkgs.tmuxPlugins.continuum
      pkgs.tmuxPlugins.tmux-thumbs
      pkgs.tmuxPlugins.tmux-fzf
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
