{ self, ... }:

{
  flake.nixosModules.desktop = { pkgs, ... }: {
    fonts.packages = [ pkgs.nerd-fonts.hurmit ];

    imports = [
      self.nixosModules.music
      self.nixosModules.alacritty
      self.nixosModules.sway
      self.nixosModules.qutebrowser
    ];
  };
}
