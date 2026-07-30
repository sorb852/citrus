{ self, ... }:

{
  flake.nixosModules.desktop = {
    imports = [
      self.nixosModules.music
      self.nixosModules.alacritty
      self.nixosModules.sway
    ];
  };
}
