{ self, inputs, ... }:

{
  flake.nixosModules.sway = { pkgs, ... }: {
    imports = [ self.nixosModules.sourshell ];
    preferences.greeter.cmd = "sway";
    programs.sway = {
      enable = true;
      package = self.packages.${pkgs.system}.sway;
    };
  };

  perSystem = { lib, pkgs, ... }: {
    packages.nikocursors = pkgs.stdenv.mkDerivation {
      name = "niko-oneshot-cursors";
      src = ../assets/nikocursors;
      # dontBuild = true;
      installPhase = /* bash */ ''
        runHook preInstall
        mkdir -p $out/share/icons/niko-oneshot-cursors
        cp -r . $out/share/icons/niko-oneshot-cursors
        runHook postInstall
      '';
    };
    packages.sway = inputs.wrappers.lib.wrapPackage (
      let
        sourshell = lib.getExe self.packages.${pkgs.system}.sourshell;
        fixColor = col: lib.strings.removePrefix "#" col;
        conf = pkgs.writeText "config" ''
          set $Mod Mod4

          output * bg ${../assets/wallpaper.jpg} fill
          output ePD-1 {
            mode 1920x1080@144Hz
            scale 1
          }

          seat * xcursor_theme niko-oneshot-cursors 24
          exec_always {
            gsettings set org.gnome.desktop.interface cursor-theme 'niko-oneshot-cursors'
            gsettings set org.gnome.desktop.interface cursor-size 24
          }

          exec ${sourshell}
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

          bindsym $Mod+Return exec ${lib.getExe self.packages.${pkgs.system}.foot}
          bindsym $Mod+q kill
          bindsym $Mod+space exec ${sourshell} ipc call launcher open
          bindsym $Mod+Shift+c reload

          bindsym $Mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit' --background ${fixColor self.theme.base08} --border ${fixColor self.theme.base09} --border-bottom ${fixColor self.theme.base09} --button-background ${fixColor self.theme.base09} --text ${fixColor self.theme.base00} --button-text ${fixColor self.theme.base00} --border-bottom-size 0
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

          bindsym --locked XF86AudioMute exec ${sourshell} ipc call audio mute
          bindsym --locked XF86AudioLowerVolume exec ${sourshell} ipc call audio dec 5
          bindsym --locked XF86AudioRaiseVolume exec ${sourshell} ipc call audio inc 5

          bindsym --locked XF86AudioPlay exec playerctl play-pause
          bindsym --locked XF86AudioPause exec playerctl play-pause
          bindsym --locked XF86AudioPrev exec playerctl previous
          bindsym --locked XF86AudioNext exec playerctl next
          bindsym --locked XF86AudioStop exec playerctl stop

          bindsym --locked XF86MonBrightnessDown exec ${sourshell} ipc call backlight dec 5
          bindsym --locked XF86MonBrightnessUp exec ${sourshell} ipc call backlight inc 5

          # TODO: specialize
          bindsym Print exec grim
        '';
        x11fallbackIndex = pkgs.writeTextFile {
          name = "x11-nikocursors-fallback";
          destination = "/share/icons/default/index.theme";
          text = ''
            [Icon Theme]
            Name=Default
            Comment=Default Cursor Theme
            Inherits=niko-oneshot-cursors
          '';
        };
      in
      {
        inherit pkgs;
        package = pkgs.sway;
        runtimePkgs = [
          pkgs.grim
          pkgs.wireplumber
          pkgs.playerctl
          pkgs.brightnessctl

          pkgs.glib
          self.packages.${pkgs.system}.nikocursors
        ];

        flags = {
          "--config" = conf;
          "--unsupported-gpu" = true;
        };

        env = {
          XCURSOR_THEME = "niko-oneshot-cursors";
          XCURSOR_SIZE = "24";
          XCURSOR_PATH = "${
            self.packages.${pkgs.system}.nikocursors
          }/share/icons:${x11fallbackIndex}/share/icons:";
        };

        passthru = (pkgs.sway.passthru or { }) // {
          providedSessions = pkgs.sway.providedSessions or [ "sway" ];
        };
      }
    );
  };
}
