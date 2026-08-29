{ ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        color_scheme = 'Catppuccin Frappe',
        scrollback_lines = 50000,
        font_size = 22,
        window_decorations = 'RESIZE',
        hide_tab_bar_if_only_one_tab = true,
        enable_tab_bar = false,
        -- Via login shell: GUI-launched WezTerm lacks the nix PATH (launchd env).
        -- Loop reattaches to main after detach or after exiting another session;
        -- only closing main itself ends the loop and closes the window.
        default_prog = { '/bin/zsh', '-l', '-c',
          'while true; do tmux new-session -A -s main || { exec zsh; }; tmux has-session -t main || break; done' },
        window_padding = { left = 5, right = 5, top = 5, bottom = 5 },
        keys = {
          { key = '/', mods = 'CTRL', action = wezterm.action.SendString("\x1f") },
          { key = 'w', mods = 'CMD', action = wezterm.action.CloseCurrentPane { confirm = false } },
          { key = '8', mods = 'CTRL', action = wezterm.action.PaneSelect },
        },
      }
    '';
  };
}
