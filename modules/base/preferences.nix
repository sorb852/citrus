{ inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  flake.nixosModules.preferences = {
    options.preferences = {
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "nixos";
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "sorb852";
      };
      greeter.cmd = lib.mkOption {
        type = lib.types.str;
        default = "sh";
      };
    };
  };
}
