# i want you to chug a beer everytime "sourshell" is mentioned in this module

{ inputs, self, ... }:

{
  flake.nixosModules.sourshell = { config, pkgs, ... }: {
    environment.systemPackages = [ self.packages.${pkgs.system}.sourshell ];
    users.users.${config.preferences.user}.extraGroups = [ "video" ];
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
    '';
  };

  perSystem = { pkgs, ... }: {
    packages.sourshell = inputs.wrappers.wrappers.quickshell.wrap {
      inherit pkgs;
      configDir = ./sourshell;
      env.SOURSHELL_THEME_JSON = pkgs.writeText "colors.json" (
        builtins.toJSON {
          inherit (self.theme)
            base00
            base01
            base02
            base03
            base04
            base05
            base06
            base07
            base08
            base09
            base0A
            base0B
            base0C
            base0D
            base0E
            base0F
            ;
        }
      );
    };
  };
}
