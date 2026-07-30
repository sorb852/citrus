# Basically a nix file for those using nixos and nixos only.
# So WSL and Mac users or even other linux distro hosts not toucing this.
{ self, ... }:

{
  flake.nixosModules.system =
    { pkgs, config, ... }:
    {
      # Other system related modules
      imports = [
        self.nixosModules.users
        self.nixosModules.locale
        self.nixosModules.greetd
      ];

      # Audio
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        jack.enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # extraConfig.pipewire = {
        #   "10-clock-rates" = {
        #     "context.properties" = {
        #       "default.clock.rate" = 48000;
        #       "default.clock.allowed-rates" = [
        #         44100
        #         48000
        #       ];
        #
        #       "default.clock.quantum" = 1024;
        #       "default.clock.min-quantum" = 512;
        #       "default.clock.max-quantum" = 2048;
        #     };
        #   };
        # };
      };
      environment.systemPackages = with pkgs; [
        # pulseaudio
        wireplumber
      ];

      # Bluetooth
      hardware.bluetooth.enable = true;

      # Bootloader
      boot.loader.systemd-boot.enable = true;

      # Sysrq for crash handling
      boot.kernel.sysctl."kernel.sysrq" = 502;

      # Networking
      networking.hostName = config.preferences.hostname;
      networking.networkmanager.enable = true;
      networking.networkmanager.wifi.powersave = false;

      # Power management
      services.upower.enable = true;

      # as you notice i got a little pissed off
      #
      # i swear if that damn mammal touches my pc again
      # genuinely why does he have to do that
      # whats with toddlers ragebaiting
      # cant even ethically ragebait too
      # genuine bum behaviour
      services.logind.settings.Login.HandlePowerKey = "ignore";

      # SSH
      services.openssh.enable = true;

      security.polkit.enable = true;

      # Fonts
      fonts.packages = with pkgs; [
        # nerd-fonts.hurmit

        ankacoder-condensed
        nerd-fonts.symbols-only
      ];

      console.font = "Anka/Coder Condensed";

      # Groups
      users.users.${config.preferences.user}.extraGroups = [
        "audio"
        "networkmanager"
      ];
    };
}
