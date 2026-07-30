{
  flake.nixosModules.scripting = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.bun
      pkgs.python3
      pkgs.gcc
    ];
  };
}
