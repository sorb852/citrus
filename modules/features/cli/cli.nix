{ self, ... }:

{
  flake.nixosModules.cli =
    { lib, pkgs, ... }:
    {
      imports = [
        self.nixosModules.tmux
        self.nixosModules.shell
        self.nixosModules.ohmyposh
        self.nixosModules.nvf
      ];

      environment.sessionVariables = {
        PAGER = "${lib.getExe pkgs.bat}";
      };

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
        pkgs.wl-clipboard
        pkgs.ripgrep
        pkgs.fd
        pkgs.jq
        pkgs.btop
        pkgs.yt-dlp
        pkgs.eza
        pkgs.fastfetch # TODO: Make seperate
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
            # apparently its a bad idea to have your email be public
            # but like atp does it matter? theres like atleast 30 more repos with my email address intact (including this one)
            user.email = "173787358+sorb852@users.noreply.github.com ";
            init.defaultBranch = "main";
          };
        };
        lazygit.enable = true;
        htop.enable = true;
      };
    };
}
