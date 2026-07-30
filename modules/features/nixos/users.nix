{ self, ... }:

{
  # Users
  flake.nixosModules.users =
    { pkgs, config, ... }:
    {
      users.users.${config.preferences.user} = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "dialout"
          "input"
        ];
        shell = pkgs.bash;
      };
    };
}
