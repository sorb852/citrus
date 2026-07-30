{ self, inputs, ... }:

{
  flake.nixosModules.alacritty = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.system}.alacritty
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.alacritty = inputs.wrappers.wrappers.alacritty.wrap {
      inherit pkgs;
      runtimePkgs = [ pkgs.nerd-fonts.hurmit ];

      settings = {
        window = {
          opacity = 0.9;
          blur = true;
        };

        font = {
          size = 11;
          normal.family = "Hurmit Nerd Font";
        };

        colors = {
          primary = {
            background = "${self.theme.base00}";
            foreground = "${self.theme.base05}";
          };

          cursor = {
            text = "${self.theme.base00}";
            cursor = "${self.theme.base05}";
          };

          normal = {
            black = "${self.theme.base00}";
            red = "${self.theme.base08}";
            green = "${self.theme.base0B}";
            yellow = "${self.theme.base0A}";
            blue = "${self.theme.base0D}";
            magenta = "${self.theme.base0E}";
            cyan = "${self.theme.base0C}";
            white = "${self.theme.base05}";
          };

          bright = {
            black = "${self.theme.base03}";
            red = "${self.theme.base08}";
            green = "${self.theme.base0B}";
            yellow = "${self.theme.base0A}";
            blue = "${self.theme.base0D}";
            magenta = "${self.theme.base0E}";
            cyan = "${self.theme.base0C}";
            white = "${self.theme.base07}";
          };
          indexed_colors = [
            {
              index = 16;
              color = "${self.theme.base09}";
            }
            {
              index = 17;
              color = "${self.theme.base0F}";
            }
            {
              index = 18;
              color = "${self.theme.base01}";
            }
            {
              index = 19;
              color = "${self.theme.base02}";
            }
            {
              index = 20;
              color = "${self.theme.base04}";
            }
            {
              index = 21;
              color = "${self.theme.base06}";
            }
          ];
        };
      };
    };
  };
}
