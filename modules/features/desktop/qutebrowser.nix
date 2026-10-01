{ self, inputs, ... }:

{
  flake.nixosModules.qutebrowser = { pkgs, ... }: {
    environment.systemPackages = [ self.packages.${pkgs.system}.qutebrowser ];
  };

  perSystem = { pkgs, ... }: {
    packages.qutebrowser = inputs.wrappers.lib.wrapPackage (
      { ... }:
      let
        conf = pkgs.writeText "config.py" /* py */ ''
          base00 = "${self.theme.base00}"
          base01 = "${self.theme.base01}"
          base02 = "${self.theme.base02}"
          base03 = "${self.theme.base03}"
          base04 = "${self.theme.base04}"
          base05 = "${self.theme.base05}"
          base06 = "${self.theme.base06}"
          base07 = "${self.theme.base07}"
          base08 = "${self.theme.base08}"
          base09 = "${self.theme.base09}"
          base0A = "${self.theme.base0A}"
          base0B = "${self.theme.base0B}"
          base0C = "${self.theme.base0C}"
          base0D = "${self.theme.base0D}"
          base0E = "${self.theme.base0E}"
          base0F = "${self.theme.base0F}"

          # status bar colors
          c.colors.statusbar.url.fg = base07
          c.colors.statusbar.url.warn.fg = base09
          c.colors.statusbar.url.error.fg = base08
          c.colors.statusbar.url.success.http.fg = base0B
          c.colors.statusbar.url.success.https.fg = base0C

          c.colors.statusbar.progress.bg = base09

          c.colors.statusbar.normal.fg = base07
          c.colors.statusbar.normal.bg = base01
          c.colors.statusbar.command.fg = base07
          c.colors.statusbar.command.bg = base01
          c.colors.statusbar.insert.fg = base00
          c.colors.statusbar.insert.bg = base09
          c.colors.statusbar.passthrough.fg = base00
          c.colors.statusbar.passthrough.bg = base0A
          c.colors.statusbar.caret.fg = base00
          c.colors.statusbar.caret.bg = base0B
          c.colors.statusbar.caret.selection.fg = base00
          c.colors.statusbar.caret.selection.bg = base0C

          # completion
          c.colors.completion.category.fg = base00
          c.colors.completion.category.bg = base09
          c.colors.completion.category.border.top = base09
          c.colors.completion.category.border.bottom = base09

          c.colors.completion.fg = [base07, base05, base0C]
          c.colors.completion.match.fg = base08
          c.colors.completion.even.bg = base01
          c.colors.completion.odd.bg = base02
          c.colors.completion.scrollbar.fg = base09
          c.colors.completion.scrollbar.bg = base03

          c.colors.completion.item.selected.fg = base03
          c.colors.completion.item.selected.match.fg = base00
          c.colors.completion.item.selected.bg = base09
          c.colors.completion.item.selected.border.top = base09
          c.colors.completion.item.selected.border.bottom = base09

          # context menu
          c.colors.contextmenu.disabled.fg = base03
          c.colors.contextmenu.disabled.bg = base01
          c.colors.contextmenu.menu.fg = base07
          c.colors.contextmenu.menu.bg = base01
          c.colors.contextmenu.selected.fg = base09
          c.colors.contextmenu.selected.bg = base02

          # hints
          c.colors.hints.fg = base07
          c.colors.hints.bg = base01
          c.colors.hints.match.fg = base09

          # keyhints
          c.colors.keyhint.fg = base07
          c.colors.keyhint.bg = base01
          c.colors.keyhint.suffix.fg = base09

          # messages
          c.colors.messages.info.fg = base00
          c.colors.messages.info.bg = base0B
          c.colors.messages.info.border = base0B

          c.colors.messages.warning.fg = base00
          c.colors.messages.warning.bg = base0A
          c.colors.messages.warning.border = base0A

          c.colors.messages.error.fg = base00
          c.colors.messages.error.bg = base08
          c.colors.messages.error.border = base08

          # tabs
          c.colors.tabs.bar.bg = base01
          c.colors.tabs.odd.fg = base07
          c.colors.tabs.odd.bg = base02
          c.colors.tabs.even.fg = base07
          c.colors.tabs.even.bg = base03

          c.colors.tabs.indicator.error = base08
          c.colors.tabs.indicator.start = base0A
          c.colors.tabs.indicator.stop = base0B

          c.colors.tabs.selected.odd.fg = base00
          c.colors.tabs.selected.even.fg = base00
          c.colors.tabs.selected.odd.bg = base09
          c.colors.tabs.selected.even.bg = base09

          # webpage bg
          c.colors.webpage.bg = base00

          # downloads
          c.colors.downloads.bar.bg = base01
          c.colors.downloads.error.fg = base01
          c.colors.downloads.error.bg = base09
          c.colors.downloads.start.fg = base01
          c.colors.downloads.start.bg = base0A
          c.colors.downloads.stop.fg = base01
          c.colors.downloads.stop.bg = base0B

          # prompts
          c.colors.prompts.fg = base07
          c.colors.prompts.bg = base02
          c.colors.prompts.selected.fg = base00 # i have no fucking clue on what this does
          c.colors.prompts.selected.bg = base09 # i have no fucking clue on what this does
          c.colors.prompts.border = f'0px solid {base02}'

          c.auto_save.session = True

          config.bind("<Ctrl+l>", "config-cycle colors.webpage.darkmode.enabled")
          c.url.searchengines = {
            "DEFAULT": "https://duckduckgo.com/?q={}",
            "!yt": "https://www.youtube.com/results?search_query={}",
            # Wikis
            "!wp": "https://www.wikipedia.org/search-redirect.php?search={}",
            "!wa": "https://wiki.archlinux.org/?search={}",
            "!wn": "https://wiki.nixos.org/w/index.php?search={}"
          }

          c.colors.webpage.darkmode.enabled = True
          c.colors.webpage.preferred_color_scheme = "dark"

          c.content.notifications.enabled = True
          c.content.pdfjs = True
          c.content.autoplay = False

          c.fonts.default_family = "Hurmit Nerd Font"
          c.fonts.hints = "bold 12pt default_family"

          # AHAHAHHA RECTANGLES AHAHAHAHAHAH
          # I LOVE 90 DEgREE DANGLES TOO
          # AHAHHAHA HHAHHAHAHAH
          #
          # I'm sorry for the actions I have taken in regards of having no radius buttons, please forgive me.
          c.hints.radius = 0
          c.hints.border = "0px"
          c.keyhint.radius = 0
          c.prompt.radius = 0
          c.qt.args = None
          c.statusbar.position = "bottom"

          no_side_bar = {
            "show": "switching",
            "format": "{audio}{index}: {current_title}",
            "width": "30%"
          }

          active_side_bar = {
            "show": "always",
            "format": " | {index}",
            "width": "80"
          }

          config.bind(f"e", " ;; ".join([
              f"config-cycle tabs.show {no_side_bar["show"]} {active_side_bar["show"]}",
              f"config-cycle tabs.title.format '{no_side_bar["format"]}' '{active_side_bar["format"]}'",
              f"config-cycle tabs.width '{no_side_bar["width"]}' '{active_side_bar["width"]}'"
            ]))

          c.tabs.show = no_side_bar["show"]
          c.tabs.width = no_side_bar["width"]
          c.tabs.title.format = no_side_bar["format"]
          c.tabs.show_switching_delay = 1600
          c.tabs.background = False
          c.tabs.position = "left"
          c.tabs.title.elide = "none"

          c.downloads.location.directory = "~/Downloads"

          c.scrolling.bar = "when-searching"

          c.qt.args = ["disable-accelerated-video-decode"] # had to do because of some bug
        '';
      in
      {
        inherit pkgs;
        package = pkgs.qutebrowser;
        flags = {
          "--config-py" = conf;
        };
      }
    );
  };
}
