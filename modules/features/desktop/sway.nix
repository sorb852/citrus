{ self, inputs, ... }:

{
  flake.nixosModules.sway = { pkgs, ... }: {
    preferences.greeter.cmd = "sway";
    programs.sway = {
      enable = true;
      package = self.packages.${pkgs.system}.sway;
    };
  };

  perSystem = { lib, pkgs, ... }: {
    packages.sway = inputs.wrappers.lib.wrapPackage (
      { ... }:
      let
        conf = pkgs.writeText "config" ''
          set $Mod Mod4
          set $menu wmenu-run

	  output * bg ${../assets/wallpaper.jpg} fill
	  output ePD-1 {
	    mode 1920x1080@144Hz
	    scale 1
	  }
          
          exec ${lib.getExe pkgs.swayidle} -w \
                   timeout 300 '${lib.getExe pkgs.swaylock} -f -c 000000' \
                   timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
                   before-sleep '${lib.getExe pkgs.swaylock} -f -c 000000'

	  font Hurmit Nerd Font, 11
	  default_border pixel 2 # maybe use normal

	  client.focused ${self.theme.base09} ${self.theme.base09} ${self.theme.base00} ${self.theme.base08} ${self.theme.base09}
	  client.urgent ${self.theme.base08} ${self.theme.base08} ${self.theme.base00} ${self.theme.base08} ${self.theme.base08}

	  client.focused_inactive ${self.theme.base03} ${self.theme.base03} ${self.theme.base06} ${self.theme.base08} ${self.theme.base03}
	  client.focused_tab_title ${self.theme.base03} ${self.theme.base03} ${self.theme.base06} ${self.theme.base08} ${self.theme.base03}
	  client.unfocused ${self.theme.base03} ${self.theme.base03} ${self.theme.base06} ${self.theme.base08} ${self.theme.base03}
          
          input type:keyboard {
              xkb_layout "us,mn"
              xkb_options "grp:alt_shift_toggle"
          }

	  focus_follows_mouse yes
	  focus_wrapping no
	  mode tiled
          
          bindsym $Mod+Return exec ${lib.getExe self.packages.${pkgs.system}.alacritty}
          bindsym $Mod+q kill
          bindsym $Mod+space exec $menu
          bindsym $Mod+Shift+c reload
          
          bindsym $Mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'
          bindsym $Mod+h focus left
          bindsym $Mod+j focus down
          bindsym $Mod+k focus up
          bindsym $Mod+l focus right
          
          bindsym $Mod+Alt+h move left
          bindsym $Mod+Alt+j move down
          bindsym $Mod+Alt+k move up
          bindsym $Mod+Alt+l move right

          # Switch to workspace
          bindsym $Mod+1 workspace number 1
          bindsym $Mod+2 workspace number 2
          bindsym $Mod+3 workspace number 3
          bindsym $Mod+4 workspace number 4
          bindsym $Mod+5 workspace number 5
          bindsym $Mod+6 workspace number 6
          bindsym $Mod+Shift+1 move container to workspace number 1
          bindsym $Mod+Shift+2 move container to workspace number 2
          bindsym $Mod+Shift+3 move container to workspace number 3
          bindsym $Mod+Shift+4 move container to workspace number 4
          bindsym $Mod+Shift+5 move container to workspace number 5
          bindsym $Mod+Shift+6 move container to workspace number 6

          bindsym $Mod+v splith
          bindsym $Mod+s splitv
          bindsym $Mod+f fullscreen
          bindsym $Mod+Shift+space floating toggle
          bindsym $Mod+Alt+space focus mode_toggle

          bindsym $Mod+Shift+minus move scratchpad
          bindsym $Mod+minus scratchpad show

          bindsym $Mod+Shift+h resize shrink width 10px
          bindsym $Mod+Shift+j resize grow height 10px
          bindsym $Mod+Shift+k resize shrink height 10px
          bindsym $Mod+Shift+l resize grow width 10px

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
          
          # TODO: specialize
          bindsym Print exec grim
          
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
	runtimePkgs = [ pkgs.grim ];

        flags = {
          "--config" = conf;
	  "--unsupported-gpu" = true;
        };

        passthru = (pkgs.sway.passthru or { }) // {
          providedSessions = pkgs.sway.providedSessions or [ "sway" ];
        };
      }
    );
  };
}
