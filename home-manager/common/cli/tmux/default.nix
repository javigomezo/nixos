{pkgs, ...}: let
  nord-tmux = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "2405";
    src = pkgs.fetchFromGitHub {
      owner = "javigomezo";
      repo = "nord-tmux";
      rev = "255814eebd2bbc1ddbb7a22367b1e4c20477e286";
      sha256 = "sha256-diZbPWq0/eGdR6f7i5qDLtJC/4ePSDsoPstEtI12GOo=";
    };
  };
in {
  programs.tmux = {
    enable = true;
    clock24 = true;
    escapeTime = 50;
    terminal = "tmux-256color";
    historyLimit = 5000;
    mouse = true;
    newSession = true;
    plugins = [
      {
        plugin = nord-tmux;
        extraConfig = ''
          set -g @nord-tmux f
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
          set -g @catppuccin_status_modules_right "directory meetings date_time"
          set -g @catppuccin_status_modules_left "session"
          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator " "
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"
          set -g @catppuccin_directory_text "#{b:pane_current_path}"
          set -g @catppuccin_date_time_text "%H:%M"
        '';
      }
    ];
    extraConfig = ''
      set -g status-position top

      # Shortcuts to Switch panes with vim keys
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-h select-pane -L
      bind -n M-l select-pane -R

      # Shortcut to reload tmux config
      bind -n M-r source-file ~/.config/tmux/tmux.conf
    '';
  };
}
