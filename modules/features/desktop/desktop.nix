{ self, ... }:

{
  flake.nixosModules.desktop = { pkgs, ... }: {
    fonts.packages = [ pkgs.nerd-fonts.hurmit ];

    imports = [
      self.nixosModules.music
      self.nixosModules.foot
      self.nixosModules.sway
      self.nixosModules.gaming
      self.nixosModules.creative
      self.nixosModules.qutebrowser
    ];
  };
}
