{ self, inputs, ... }:

{
  flake.nixosModules.foot = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.system}.foot
    ];
  };

  perSystem = { lib, pkgs, ... }: {
    packages.foot = inputs.wrappers.wrappers.foot.wrap (
      let
        fixColor = col: lib.strings.removePrefix "#" col;
      in
      {
        inherit pkgs;

        settings = {
          main = {
            font = "Hurmit Nerd Font:size=11";
            shell = "tmux";
          };

          "colors-dark" = {
            cursor = "${fixColor self.theme.base00} ${fixColor self.theme.base05}";

            foreground = "${fixColor self.theme.base05}";
            background = "${fixColor self.theme.base00}";

            regular0 = "${fixColor self.theme.base00}";
            regular1 = "${fixColor self.theme.base08}";
            regular2 = "${fixColor self.theme.base0B}";
            regular3 = "${fixColor self.theme.base0A}";
            regular4 = "${fixColor self.theme.base0D}";
            regular5 = "${fixColor self.theme.base0E}";
            regular6 = "${fixColor self.theme.base0C}";
            regular7 = "${fixColor self.theme.base05}";

            bright0 = "${fixColor (self.theme.brighten 0.10 self.theme.base03)}";
            bright1 = "${fixColor (self.theme.brighten 0.15 self.theme.base08)}";
            bright2 = "${fixColor (self.theme.brighten 0.15 self.theme.base0B)}";
            bright3 = "${fixColor (self.theme.brighten 0.15 self.theme.base0A)}";
            bright4 = "${fixColor (self.theme.brighten 0.15 self.theme.base0D)}";
            bright5 = "${fixColor (self.theme.brighten 0.15 self.theme.base0E)}";
            bright6 = "${fixColor (self.theme.brighten 0.15 self.theme.base0C)}";
            bright7 = "${fixColor (self.theme.brighten 0.10 self.theme.base07)}";

            alpha = 0.9;
            blur = true;

            selection-foreground = "${fixColor self.theme.base01}";
            selection-background = "${fixColor self.theme.base09}";
          };
        };
      }
    );
  };
}
