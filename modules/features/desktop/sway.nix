{ self, inputs, ... }:

{
  flake.nixosModules.sway = { pkgs, ... }: {
    preferences.greeter.cmd = "sway";
    programs.sway = {
      enable = true;
      package = self.packages.${pkgs.system}.sway;
    };
  };

  perSystem = { pkgs, ... }: {
    packages.sway = inputs.wrappers.lib.wrapPackage (
      { ... }:
      let
        conf = pkgs.writeText "config" ''
          set $mod Mod4
          set $menu wmenu-run
          
          ### Output configuration
          #
          # Default wallpaper
          #output * bg ~/.config/sway/backgrounds/Sway_Wallpaper_Blue_1920x1080.png fill
          #
          # Example configuration:
          #
          #   output HDMI-A-1 resolution 1920x1080 position 1920,0
          #
          # You can get the names of your outputs by running: swaymsg -t get_outputs
          
          ### Idle configuration
          #
          # Example configuration:
          #
          # exec swayidle -w \
          #          timeout 300 'swaylock -f -c 000000' \
          #          timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
          #          before-sleep 'swaylock -f -c 000000'
          #
          # This will lock your screen after 300 seconds of inactivity, then turn off
          # your displays after another 300 seconds, and turn your screens back on when
          # resumed. It will also lock your screen before your computer goes to sleep.
          
          ### Input configuration
          #
          # Example configuration:
          #
          #   input type:touchpad {
          #       dwt enabled
          #       tap enabled
          #       natural_scroll enabled
          #       middle_emulation enabled
          #   }
          #
          #   input type:keyboard {
          #       xkb_layout "eu"
          #   }
          #
          # You can also configure each device individually.
          # Read `man 5 sway-input` for more information about this section.
          
          ### Key bindings
          #
          # Basics:
          #
              bindsym $mod+Return exec ${self.packages.${pkgs.system}.alacritty}
              bindsym $mod+q kill
              bindsym $mod+d exec $menu
              bindsym $mod+Shift+c reload
          
              # Exit sway (logs you out of your Wayland session)
              bindsym $mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'
              bindsym $mod+h focus left
              bindsym $mod+j focus down
              bindsym $mod+k focus up
              bindsym $mod+l focus right
          
              bindsym $mod+Shift+h move left
              bindsym $mod+Shift+j move down
              bindsym $mod+Shift+k move up
              bindsym $mod+Shift+l move right

              # Switch to workspace
              bindsym $mod+1 workspace number 1
              bindsym $mod+2 workspace number 2
              bindsym $mod+3 workspace number 3
              bindsym $mod+4 workspace number 4
              bindsym $mod+5 workspace number 5
              bindsym $mod+6 workspace number 6
              # bindsym $mod+7 workspace number 7
              # bindsym $mod+8 workspace number 8
              # bindsym $mod+9 workspace number 9
              # bindsym $mod+0 workspace number 10
              # Move focused container to workspace
              bindsym $mod+Shift+1 move container to workspace number 1
              bindsym $mod+Shift+2 move container to workspace number 2
              bindsym $mod+Shift+3 move container to workspace number 3
              bindsym $mod+Shift+4 move container to workspace number 4
              bindsym $mod+Shift+5 move container to workspace number 5
              bindsym $mod+Shift+6 move container to workspace number 6
              # bindsym $mod+Shift+7 move container to workspace number 7
              # bindsym $mod+Shift+8 move container to workspace number 8
              # bindsym $mod+Shift+9 move container to workspace number 9
              # bindsym $mod+Shift+0 move container to workspace number 10

              bindsym $mod+v splith
              bindsym $mod+s splitv
              bindsym $mod+f fullscreen
              bindsym $mod+Shift+space floating toggle
              bindsym $mod+Alt+space focus mode_toggle

              bindsym $mod+Shift+minus move scratchpad
              bindsym $mod+minus scratchpad show

              bindsym h resize shrink width 10px
              bindsym j resize grow height 10px
              bindsym k resize shrink height 10px
              bindsym l resize grow width 10px

              bindsym --locked XF86AudioMicMute exec wpctl set-mute @DEFAULT_SOURCE@ toggle
              bindsym --locked XF86AudioMute exec pactl set-mute @DEFAULT_SINK@ toggle
              bindsym --locked XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_SINK@ 5%-
              bindsym --locked XF86AudioRaiseVolume exec wpctl set-volume @DEFAULT_SINK@ 5%+
              
              bindsym --locked XF86AudioPlay exec playerctl play-pause
              bindsym --locked XF86AudioPause exec playerctl play-pause
              bindsym --locked XF86AudioPrev exec playerctl previous
              bindsym --locked XF86AudioNext exec playerctl next
              bindsym --locked XF86AudioStop exec playerctl stop
              
              bindsym --locked XF86MonBrightnessDown exec brightnessctl set 5%-
              bindsym --locked XF86MonBrightnessUp exec brightnessctl set 5%+
              
              # Special key to take a screenshot with grim
              bindsym Print exec grim
              
              #
              # Status Bar:
              #
              # Read `man 5 sway-bar` for more information about this section.
              bar {
                  position top
              
                  # When the status_command prints a new line to stdout, swaybar updates.
                  # The default just shows the current date and time.
                  status_command while date +'%Y-%m-%d %X'; do sleep 1; done
              
                  colors {
                      statusline #ffffff
                      background #323232
                      inactive_workspace #32323200 #32323200 #5c5c5c
                  }
              }
        '';
      in
      {
        inherit pkgs;
        package = pkgs.sway;
        flags = {
          "--config" = conf;
        };

        passthru = (pkgs.sway.passthru or { }) // {
          providedSessions = pkgs.sway.providedSessions or [ "sway" ];
        };
      }
    );
  };
}
