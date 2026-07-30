{ inputs, ... }:
{
  imports = [
    inputs.wrappers.flakeModules.wrappers
  ];

  systems = [
    "x86_64-linux"
    # Hopefully these work
    # Well not my problem now is it
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];
}
