{ self, ... }:

{
  flake.nixosModules.cli =
    { lib, pkgs, ... }:
    {
      imports = [
        self.nixosModules.tmux
        self.nixosModules.shell
        self.nixosModules.ohmyposh
      ];

      environment.sessionVariables = {
        PAGER = "${lib.getExe pkgs.bat}";
      };

      # TODO: ykw js wrapp all these
      environment.systemPackages = [
        pkgs.wget
        pkgs.curl
        pkgs.spotdl
        pkgs.unzip
        pkgs.p7zip
        pkgs.unrar
        pkgs.mpv
        pkgs.devenv
        pkgs.file
        pkgs.tldr
        pkgs.fastfetch # TODO: Make seperate
        pkgs.ripgrep
        pkgs.fd
        pkgs.jq
        pkgs.btop
        pkgs.yt-dlp
        pkgs.eza
	pkgs.neovim
      ];

      programs = {
        bat.enable = true;
        fzf = {
          # idk i just now that this enables fzf
          fuzzyCompletion = true;
          keybindings = true;
        };
        zoxide = {
          enable = true;
          enableZshIntegration = true;
        };

        git = {
          enable = true;
          config = {
            # TODO: make this host dependant
            user.name = "sorb852";
            user.email = "reeldob34@gmail.com";
            init.defaultBranch = "main";
          };
        };
        lazygit.enable = true;
        htop.enable = true;
      };
    };
}
