{ self, ... }:

{
  flake.nixosModules.greetd =
    { pkgs, config, ... }:
    {
      # Greeter
      services.greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --cmd ${config.preferences.greeter.cmd}";
            user = "${config.preferences.user}";
          };
          default_session = initial_session;
        };
      };

      systemd.services.greetd.serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "journal";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };
    };
}
