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
          base16-nvim
          nvim-colorizer-lua
          lualine-nvim
        ];
        config = "require('init')";
      };
      settings.config_directory = ./.;
    };
  };
}
