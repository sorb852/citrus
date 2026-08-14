{ lib, ... }:

{
  flake.nixosModules.shell = { pkgs, ... }: {
    programs.bash = {
      enable = true;
      # completion.enable = true;

      interactiveShellInit = ''
        # TMUX my love
        # if [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
        # exec ${lib.getExe pkgs.tmux} new-session
        # fi
      '';

      shellAliases = {
        cls = "clear";
        ls = "ls --color=auto"; # yeah good luck using this when theres eza
        grep = "grep --color=auto"; # idk ripgrep is there too
        e = "${lib.getExe pkgs.eza} --color=always";
        ds = "devenv shell";
      };
    };
  };
}
