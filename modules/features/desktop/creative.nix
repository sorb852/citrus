{
  flake.nixosModules.creative = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.arduino-ide ];
  };
}
