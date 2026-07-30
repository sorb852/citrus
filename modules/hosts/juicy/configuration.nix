{ inputs, self, ... }:
let
  system = "x86_64-linux";
in
{
  flake.nixosModules.Juicy = {
    preferences.hostname = "Juicy";
    system.stateVersion = "26.05";
  };

  flake.nixosConfigurations.Juicy = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      self.nixosModules.base
      self.nixosModules.system
      self.nixosModules.cli
      self.nixosModules.desktop
      self.nixosModules.scripting
      self.nixosModules.Juicy
      self.nixosModules.JuicyHardware
    ];
  };
}
