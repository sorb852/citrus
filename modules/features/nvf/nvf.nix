# TODO: oh yeah i love making todos. guess what here is another todo. go and remove this for me once were done
{ self, inputs, ... }:

{
  perSystem = { pkgs, ... }: {
    packages.nvf =
      (inputs.nvf.lib.neovimConfiguration {
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
            vim.opts = {
              completeopt = "menu,menuone,noselect,popup,fuzzy";
              cursorline = true;
              expandtab = true;
              number = true;
              relativenumber = true;
              tabstop = 2;
              shiftwidth = 2;
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
              # clipboard = "unnamedplus";
            };
            # look, youll never know if id be using sway or bspwm tomorrow
            vim.clipboard = {
              enable = true;
              providers.wl-copy.enable = true;
              # providers.xclip.enable = true;
            };
          }
          # autogroups and autocmds
          ({ lib, ... }: {
            vim.augroups = [
              { name = "highlight_yank"; }
            ];
            vim.autocmds = [
              {
                event = [ "TextYankPost" ];
                group = "highlight_yank";
                desc = "Highlight selection on yank";
                pattern = [ "*" ];
                callback = lib.mkLuaInline /* lua */ ''
                  function()
                    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 100 }
                  end
                '';
              }
            ];
          })
          # base keymaps
          {
            vim.keymaps = [
              {
                mode = [ "n" ];
                key = "<Esc>";
                action = "<cmd>nohlsearch<CR>";
              }
              {
                mode = [ "n" ];
                key = "U";
                action = "<cmd>redo<CR>";
              }
              {
                mode = [ "n" ];
                key = "<leader>bd";
                action = "<cmd>bd<CR>";
              }
            ];
          }
          # plugins
          ({ lib, ... }: {
            vim.autopairs.nvim-autopairs = {
              # TODO: consider if needed
              enable = true;
              setupOpts.map_cr = false;
            };
            # TODO: maybe check out dashboards? like yeah theyre cool and all but i dont want them to be in center and would LOOOVE to have a simple animation there too
            vim.mini = {
              files.enable = true;
              pick.enable = true;
            };
            vim.keymaps = [
              {
                mode = [ "n" ];
                key = "<leader>sf";
                action = "<cmd>Pick files<CR>";
              }
              {
                mode = [ "n" ];
                key = "<leader>sg";
                action = "<cmd>Pick grep_live<CR>";
              }
              {
                mode = [ "n" ];
                key = "<leader>sh";
                action = "<cmd>Pick help<CR>";
              }
              {
                mode = [ "n" ];
                key = "<leader><space>";
                action = "<cmd>Pick buffers<CR>";
              }
              {
                mode = [ "n" ];
                key = "<leader>e";
                action = "function() MiniFiles.open() end";
                lua = true;
              }
            ];
            # TODO: vim.notes.todo-comments
            # TODO: vim.notify
            vim.statusline.lualine = {
              enable = true;
              theme = "base16";
              globalStatus = false;
              icons.enable = false;
              componentSeparator = {
                left = " ";
                right = " ";
              };
              sectionSeparator = {
                left = " ";
                right = " ";
              };
              activeSection = {
                a = [ "'mode'" ];
                b = [ ];
                c = [ ];
                x = [ ];
                y = [ "'branch'" ];
                z = [ "'filename'" ];
              };
              inactiveSection = {
                a = [ ];
                b = [ ];
                c = [ ];
                x = [ "'filetype'" ];
                y = [ "'filename'" ];
                z = [ ];
              };
              setupOpts.options.theme = lib.mkLuaInline /* lua */ ''
                (function()
                  local colors = require('base16-colorscheme').colors
                  local default_cols = { fg = colors.base07, bg = colors.base01 }
                  local line = {
                    a = { fg = colors.base00, bg = colors.base09, gui = 'bold' },
                    b = default_cols,
                    c = default_cols,
                    x = default_cols,
                    y = default_cols,
                    z = { fg = colors.base00, bg = colors.base09, gui = 'bold' },
                  }

                  return {
                    normal = line,
                    insert = line,
                    visual = line,
                    replace = line,
                    command = line,
                    inactive = line,
                  }
                end)()
              '';
            };

            vim.lazy.plugins = {
              "lazygit.nvim" = {
                package = pkgs.vimPlugins.lazygit-nvim;
                lazy = true;
                cmd = [
                  "LazyGit"
                  "LazyGitConfig"
                  "LazyGitCurrentFile"
                  "LazyGitFilter"
                  "LazyGitFilterCurrentFile"
                ];
                keys = [
                  {
                    mode = "n";
                    key = "<leader>g";
                    action = "<cmd>LazyGit<CR>";
                  }
                ];
              };
            };
            # vim.terminal.toggleterm.enable = true;
            # vim.terminal.toggleterm.lazygit = {
            #   enable = true;
            #   mappings.open = "<leader>g";
            # };
          })
          # lsp
          ({ lib, ... }: {
            # TODO: check out diagnostics and debuggers
            vim.augroups = [
              { name = "native_completion"; }
            ];
            vim.autocmds = [
              {
                event = [ "LspAttach" ];
                group = "native_completion";
                desc = "Enable native LSP completion on every client attach";
                callback = lib.mkLuaInline /* lua */ ''
                  function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client and client:supports_method("textDocument/completion") then
                      vim.lsp.completion.enable(true, args.data.client_id, args.buf, {
                        autotrigger = false,
                        convert = function(item)
                          if item.label then
                            item.abbr = item.label:gsub('%b()', "")
                          end
                          return item
                        end
                      })
                    end
                  end
                '';
              }
            ];
            vim.keymaps = [
              {
                mode = [ "i" ];
                key = "<C-Space>";
                action = /* lua */ "function() vim.lsp.completion.get() end";
                lua = true;
              }
              {
                mode = [ "i" ];
                key = "<CR>";
                action = /* lua */ ''
                  function()
                    if vim.fn.pumvisible() == 1 and vim.fn.complete_info().selected ~= -1 then
                      return vim.api.nvim_replace_termcodes('<C-y>', true, true, true)
                    end
                    if package.loaded['nvim-autopairs'] then
                      local keys = require('nvim-autopairs').completion_confirm()
                      vim.schedule(function()
                        vim.api.nvim_feedkeys(keys, 'n', false)
                      end)
                      return ""
                      -- return require('nvim-autopairs').completion_confirm()
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
              clang.enable = true;
              nix.enable = true;
              go.enable = true;
              zig.enable = true;
            };
          })
          {
            vim.theme = {
              enable = true;
              name = "base16";
              base16-colors = {
                base00 = "${self.theme.base00}";
                base01 = "${self.theme.base01}";
                base02 = "${self.theme.base02}";
                base03 = "${self.theme.base03}";
                base04 = "${self.theme.base04}";
                base05 = "${self.theme.base05}";
                base06 = "${self.theme.base06}";
                base07 = "${self.theme.base07}";
                base08 = "${self.theme.base08}";
                base09 = "${self.theme.base09}";
                base0A = "${self.theme.base0A}";
                base0B = "${self.theme.base0B}";
                base0C = "${self.theme.base0C}";
                base0D = "${self.theme.base0D}";
                base0E = "${self.theme.base0E}";
                base0F = "${self.theme.base0F}";
              };
            };
          }
        ];
      }).neovim;
  };
}
