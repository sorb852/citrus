{ self, ... }:

{
  flake.nixosModules.tmux = {
    programs.tmux = {
      enable = true;

      baseIndex = 1;
      shortcut = "a";
      keyMode = "vi";
      customPaneNavigationAndResize = true;

      resizeAmount = 5;

      extraConfig = ''
        set -g mouse on
        set -g renumber-windows on

        bind 'v' split-window -h -c "#{pane_current_path}"
        bind 's' split-window -v -c "#{pane_current_path}"

        bind c new-window -c "#{pane_current_path}"
        bind & kill-window
        bind * kill-pane
        bind n next-window
        bind p previous-window

        bind Tab copy-mode
        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi V send-keys -X select-line
        bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        bind -T copy-mode-vi Escape send-keys -X cancel

        # Appearance
        set -g pane-border-style "fg=${self.theme.base03}"
        set -g pane-active-border-style "fg=${self.theme.base09}"

        set -g status on
        set -g status-position top
        set -g status-style "bg=${self.theme.base01}"
        set -g status-justify centre

        set -g status-left " [#S]"
        set -g status-left-length 100
        set -g status-left-style "fg=${self.theme.base09}"
        set -g status-right "%H:%M "
        set -g status-right-length 100
        set -g status-right-style "fg=${self.theme.base09}"

        set -g window-status-format "#{?window_zoomed_flag,[,}#I:#W#{?window_zoomed_flag,],}"
        set -g window-status-current-format "#{?window_zoomed_flag,[,}#I:#W#{?window_zoomed_flag,],}"
        set -g window-status-style "fg=${self.theme.base07}"
        set -g window-status-current-style "fg=${self.theme.base09}"
      '';
    };
  };
}
