{ self, inputs, ... }:

{
  perSystem = { pkgs, ... }: {
    packages.neovim = inputs.wrappers.wrappers.neovim.wrap {
      inherit pkgs;
      runtimePkgs = with pkgs; [
        vscode-json-languageserver
        clang-tools
        gopls
        zls
        lazygit
        ripgrep
      ];
      specs.general = {
        data = with pkgs.vimPlugins; [
          mini-files
          mini-pick
          lazygit-nvim
          nvim-colorizer-lua
          base16-nvim
          lualine-nvim
        ];
        config = "require('init')";
      };
      settings.config_directory = ./.;
    };
  };
}
