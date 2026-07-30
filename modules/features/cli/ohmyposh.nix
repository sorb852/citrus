{ inputs, self, ... }:

{
  flake.nixosModules.ohmyposh = { lib, pkgs, ... }: 
    let
      selfpkgs = self.packages.${pkgs.system};
    in
    {
      environment.systemPackages = [ selfpkgs.ohmyposh ];
      programs.bash.interactiveShellInit = "eval \"$(${lib.getExe selfpkgs.ohmyposh} init bash)\"";
    };

  perSystem = { pkgs, ... }: {
    packages.ohmyposh = inputs.wrappers.wrappers.oh-my-posh.wrap {
      inherit pkgs;
      configFile = pkgs.writeText "theme.json" (
        builtins.toJSON {
          "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
          final_space = true;
          version = 4;
          blocks = [
            {
              type = "prompt";
              alignment = "left";
              segments = [
                {
                  type = "status";
                  style = "plain";
                  foreground = "${self.theme.base00}";
                  background = "${self.theme.base08}";
                  template = "{{ if .Error }} {{ .Code }} {{ end }}";
                }
                {
                  type = "session";
                  style = "plain";
                  foreground = "${self.theme.base09}";
                  background = "${self.theme.base02}";
                  template = " {{ .UserName }}@{{ .HostName }} ";
                }
                {
                  type = "git";
                  style = "plain";
                  foreground = "${self.theme.base00}";
                  background = "${self.theme.base0C}";
                  options = {
                    branch_icon = "";
                  };
                  template = " {{ .HEAD }} ";
                }
                {
                  type = "path";
                  style = "plain";
                  foreground = "${self.theme.base07}";
                  background = "${self.theme.base03}";
		  template = " {{ .Path }} ";
                }
                {
                  type = "text";
                  style = "plain";
                  foreground = "${self.theme.base00}";
                  background = "${self.theme.base07}";
                  template = " $ ";
                }
              ];
            }
	    {
	      type = "prompt";
	      alignment = "right";
	      segment = [
	        {
		  type = "nix-shell";
		  style = "plain";
		  foreground = "${self.theme.base0D}";
		  template = "(nix:{{ .Type }})";
		}
	      ];
	    }
          ];
        }
      );
    };
  };
}
