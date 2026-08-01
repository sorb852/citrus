# TODO: oh yeah i love making todos. guess what here is another todo. go and remove this for me once were done
{ self, inputs, ... }:

{
  perSystem = { pkgs, ... }: {
    packages.neovim = inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [
        # meta
        {
          vim.viAlias = true;
          vim.vimAlias = false; # i love me some vim for when im stuck at the tty
        }
        # basics and options
        {
          vim.syntaxHighlighting = true;
          vim.options = {
            completeopt = "menu,menuone,noselect,popup,fuzzy";
            cursorline = true;
            expandtab = true;
            number = true;
            relativenumber = true;
            tabstop = 4;
            shiftwidth = 4;
            winborder = "single";
            termguicolors = true;
            
            foldcolumn = "3";
            foldmethod = "expr";
            signcolumn = "yes";
            foldlevel = 99;
            foldlevelstart = 99;
            
            swapfile = false;
            wrap = false;
            grepprg = "rg";
            clipboard = "unnamedplus";
          };
        }
        # autogroups and autocmds
        {
          vim.augroups = [
            { name = "highlight_yank"; }
          ];
          vim.autocmds = [
            {
              event = "TextYankPost";
              group = "highlight_yank";
              desc = "Highlight selection on yank";
              pattern = "*";
              callback = /* lua */''
                function()
                  vim.highlight.on_yank { higroup = 'IncSearch', timeout = 100 }
                end
              '';
            }
          ];
        }
        # base keymaps
        {
          vim.keymaps = [
            { mode = ["n"]; key = "<Esc>"; action = "<cmd>nohlsearch<CR>"; }
            { mode = ["n"]; key = "U"; action = "<cmd>redo<CR>"; }
            { mode = ["n"]; key = "<leader>bd"; action = "<cmd>bd<CR>"; }
          ];
        }
        # plugins
        {
          vim.autopairs.nvim-autopairs.enable = true; # TODO: consider if needed
        }
        # lsp
        {
          vim.keymaps = [
            { mode = ["i"]; key = "<C-Space>"; action = /* lua */"function() vim.lsp.completion.get() end"; lua = true; }
            {
              mode = ["i"];
              key = "<CR>";
              action = /* lua */''
                function()
                  if vim.fn.pubvisible() == 1 and vim.fn.complete_info().selected ~= -1 then
                    return vim.api.nvim_replace_termcodes('<C-y>, true, true, true)
                  end
                  return vim.api.nvim_replace_termcodes('<CR>', true, true, true)
                end
              '';
              lua = true;
              expr = true;
              silent = true;
            }
          ];
          vim.lsp = {
            enable = true;
            # TODO: also consider this trouble.enable = true;
            inlayHints.enable = true; # maybe rid this
            mappings = {
              # TODO: maybe implement other mappings
              format = "<leader>f";
              hover = "K";
              renameSymbol = "grn";
            };
          };
          vim.languages = {
            enableFormat = true;
            enableTreesitter = true;
            clang = {
              enable = true;
              extraDiagnostics.enable = true;
            };
            nix = {
              enable = true;
              extraDiagnostics.enable = true;
            };
            go.enable = true;
            zig.enable = true;
          };
        }
      ];
    };
  };
}
