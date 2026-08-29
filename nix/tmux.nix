{ pkgs, ... }:

{
  services.tmux-agent-notifier.enable = true;

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    baseIndex = 1;
    escapeTime = 0;
    mouse = true;
    plugins = [
      {
        plugin = pkgs.tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "frappe"
          # No half-circle powerline cap on the left edge of each module.
          set -g @catppuccin_status_left_separator ""
          set -g @catppuccin_host_icon ""

          # Left side reads "# <badge> <session>". The "#" sits in the
          # module's icon slot. "##" is the tmux escape for a literal "#"
          # - it collapses once during #{E:} expansion.
          set -g @catppuccin_session_icon "##"
          # Drop the icon's accent chip so the "#" shares the session
          # name's background, and drive its foreground off the prefix
          # state instead: mauve while C-Space is held, normal otherwise.
          # Both are set before the plugin loads, and it only fills these
          # in when unset, so these win.
          set -g @catppuccin_status_session_icon_bg "#{E:@catppuccin_status_module_text_bg}"
          set -g @catppuccin_status_session_icon_fg "#{?client_prefix,#{E:@thm_mauve},#{E:@thm_fg}}"
          # Badge in @thm_mauve, the same accent the theme gives the
          # active window, so it stands out against the module background.
          set -g @catppuccin_session_text "#[fg=#{@thm_mauve}]#{E:@agent-notifier-badge}#[fg=#{@thm_fg}] #S"

          # Windows: one flat chip per window, no separately colored
          # number block. The plugin hardcodes the number segment's
          # foreground to @thm_crust, which is unreadable on these
          # backgrounds, so the number moves into the text segment and
          # the number segment is left empty.
          # "custom" is used purely so the separators below survive - the
          # built-in styles overwrite them unconditionally.
          set -g @catppuccin_window_status_style "custom"
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_middle_separator ""
          set -g @catppuccin_window_right_separator ""
          set -g @catppuccin_window_number ""
          set -g @catppuccin_window_current_number ""
          # #W (window name, tracked by automatic-rename) - not #T, which
          # is the pane title and defaults to the hostname, and which
          # programs like claude overwrite with their own status text.
          set -g @catppuccin_window_text " #I #W "
          set -g @catppuccin_window_current_text " #I #W "
          # No activity/bell/zoom flag glyphs appended to the name.
          set -g @catppuccin_window_flags "none"
          # Active window sits on the current background; the rest blend
          # into the status line's own (darker) background.
          set -g @catppuccin_window_current_number_color "#{@thm_surface_1}"
          set -g @catppuccin_window_current_text_color "#{@thm_surface_1}"
          set -g @catppuccin_window_number_color "#{@thm_mantle}"
          set -g @catppuccin_window_text_color "#{@thm_mantle}"
        '';
      }
      pkgs.tmuxPlugins.yank
      {
        plugin = pkgs.tmuxPlugins.resurrect;
        extraConfig = ''
          # Save on a, restore on z (prefix+r reloads the config);
          # plain-tap keys only.
          set -g @resurrect-save 'a'
          set -g @resurrect-restore 'z'
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
          # Popup at 95% like the fzf-lua window in nvim (default 62%x38%)
          set-environment -g TMUX_FZF_OPTIONS "-p -w 95% -h 95% -m"
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.fzf-tmux-url;
        extraConfig = ''
          # Defaults to u, which the zsh popup binding below overrides
          # (extraConfig is sourced after the plugins), leaving the URL
          # picker unreachable. o is a free plain-tap key.
          set -g @fzf-url-bind 'o'
        '';
      }
    ];
    extraConfig = ''
      # Auto-restore saved sessions when tmux starts (continuum + resurrect)
      set -g @continuum-restore 'on'

      # Enable 256 colors
      set -as terminal-features ",xterm-256color:RGB"

      set -g status-justify centre
      # Double-line pane borders
      set -g pane-border-lines double

      # Pane top border shows each pane's path; the border line has the
      # full pane width (the status bar was too cramped for host:dir).
      # Border text takes the active/inactive border colors from the theme.
      set -g pane-border-status top
      set -g pane-border-format " #{pane_current_path} "

      # Status line: session module on the left (built-in catppuccin
      # module - turns red while the prefix is held, green otherwise),
      # host module on the right; replaces the theme's cpu/ram right side
      # (cpu plugin removed). No colors of our own: both modules are
      # rendered entirely by the catppuccin plugin from @catppuccin_flavor.
      # status-left-length defaults to 10 and strips long session names.
      # The agent-notifier badge shows next to the session module when an
      # agent session waits for input (prefix+i opens the jump popup).
      set -g status-left-length 40
      set -g status-left "#{E:@catppuccin_status_session}"
      set -g status-right-length 40
      set -g status-right "#{E:@catppuccin_status_host}"
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
      # Nix's makeWrapper leaves the real binary as ".<name>-wrapped" and
      # tmux names the window after the executable, not argv[0] - so claude
      # shows up as ".claude-wrapped". Strip the wrapper decoration back to
      # the plain name. Otherwise this is tmux's stock format.
      set -g automatic-rename-format \
        '#{?pane_in_mode,[tmux],#{s/^\.(.*)-wrapped$/\1/:pane_current_command}}#{?pane_dead,[dead],}'

      # Killing a middle window renumbers the rest so there are no gaps
      set -g renumber-windows on

      # Enable vi mode for copy/paste
      set-window-option -g mode-keys vi

      # Configuration reload (conf is nix-managed; reload picks up rebuilds live)
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded..."

      # Window management
      bind t new-window -c "#{pane_current_path}"

      # Session management: plain-tap s, prompts for a name
      bind s command-prompt -p "new session:" "new-session -s '%%' -c '#{pane_current_path}'"

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

      # Copy/paste on home-row taps (brackets are symbol holds on the Corne)
      unbind [
      unbind ]
      bind c copy-mode
      bind p paste-buffer -p

      # Keybinding discovery: native list-keys popup, always accurate
      # (replaces next-layout, which was the default Space binding)
      bind Space list-keys -N -T prefix

      # Dropdown zsh popup: floating overlay at 85% of the screen, opens
      # in the pane's working dir (fresh shell each time). Esc closes it;
      # no -E on purpose - tmux 3.6 hardcodes Esc/C-c as popup dismiss
      # keys, which also means vi-mode's Esc never reaches the popup shell.
      bind u display-popup -d "#{pane_current_path}" -w 85% -h 85%

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
