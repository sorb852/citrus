{ self, inputs, ... }:

{
  flake.nixosModules.base = { pkgs, ... }: {
    imports = [ self.nixosModules.preferences ];

    # idk for steam and some other stuff
    nixpkgs.config.allowUnfree = true;

    # i love flakes i think idk
    # were kind of in an abusive relatiion ship
    # but trust me i can fix er
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    environment.systemPackages = with pkgs; [
      wget
      curl

      # Debugging
      tldr
      # wikiman # Seems like i have to like wrap this thing to configure it, and install arch wiki manually (make direvations)
    ];

    programs = {
      git.enable = true;
      vim.enable = true;
      bash.enable = true;
    };
  };

  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  };
}
