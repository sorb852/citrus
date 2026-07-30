{ inputs, self, ... }:
{
  flake.nixosModules.music =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      services.mpd = {
        enable = true;
        user = "${config.preferences.user}";
        settings = {
          music_directory = "/home/${config.services.mpd.user}/Music/Library/";
          audio_output = [
            {
              type = "pipewire";
              name = "Pipewire output";
            }
            {
              type = "fifo";
              name = "my_fifo";
              path = "/tmp/mpd.fifo";
              format = "44100:16:2";
            }
          ];
        };
      };
      systemd.services.mpd.environment = {
        XDG_RUNTIME_DIR = "/run/user/1000";
      };

      systemd.user.services.mpd-mpris = {
        description = "mpd-mpris provider";
        after = [ "mpd.service" ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
          ExecStart = lib.getExe pkgs.mpd-mpris;
          Restart = "on-failure";
        };
      };

      environment.systemPackages = with pkgs; [
        mpd-mpris

        self.packages.${pkgs.system}.rmpc

        # essential btw
        self.packages.${pkgs.system}.cava
        mpc
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.cava = inputs.wrappers.wrappers.cava.wrap {
        inherit pkgs;
        settings = {
          color = {
            gradient = 1;
            gradient_color_1 = "'${self.theme.base08}'";
            gradient_color_2 = "'${self.theme.base09}'";
            gradient_color_3 = "'${self.theme.base0A}'";
            gradient_color_4 = "'${self.theme.base0B}'";
            gradient_color_5 = "'${self.theme.base0C}'";
            gradient_color_6 = "'${self.theme.base0D}'";
            gradient_color_7 = "'${self.theme.base0E}'";
            gradient_color_8 = "'${self.theme.base0F}'";

            horizontal_gradient = 1;
            horizontal_gradient_color_1 = "'${self.theme.base08}'";
            horizontal_gradient_color_2 = "'${self.theme.base09}'";
            horizontal_gradient_color_3 = "'${self.theme.base0A}'";
            horizontal_gradient_color_4 = "'${self.theme.base0B}'";
            horizontal_gradient_color_5 = "'${self.theme.base0C}'";
            horizontal_gradient_color_6 = "'${self.theme.base0D}'";
            horizontal_gradient_color_7 = "'${self.theme.base0E}'";
            horizontal_gradient_color_8 = "'${self.theme.base0F}'";
          };
        };
      };
      packages.rmpc = inputs.wrappers.lib.wrapPackage (
        { ... }:
        let
          # TODO: Somehow make it work with noctalia
          theme = pkgs.writeTextDir "config/theme.ron" ''
            #![enable(implicit_some)]
            #![enable(unwrap_newtypes)]
            #![enable(unwrap_variant_newtypes)]
            (
              default_album_art_path: Some("${./assets/thedisintegrationloop.png}"), // Broter, this is the tuffest thing I have ever seen 🗿. Edit this over Tiki Tiki funk, capiche?
              symbols: (
                song: "󰝚 ",
                dir: " ",
                playlist: " ",
                marker: "> ",
                ellipsis: "...",
                song_style: None,
                dir_style: None,
                playlist_style: None,
              ),
              progress_bar: (
                symbols: ["╞", "═", "╡", "─", "┤"],
                track_style: (fg: "${self.theme.base01}"),
                elapsed_style: (fg: "${self.theme.base0C}"),
                thumb_style: (fg: "${self.theme.base0C}"),
                use_track_when_empty: false
              ),
              scrollbar: (
                symbols: ["│", "█", "┬", "┴"],
                track_style: (fg: "${self.theme.base01}"),
                ends_style: (fg: "${self.theme.base01}"),
                thumb_style: (fg: "${self.theme.base0F}"),
              ),
              cava: (
                bar_color: Gradient({
                  0  : "${self.theme.base08}",
                  14 : "${self.theme.base09}",
                  29 : "${self.theme.base0A}",
                  43 : "${self.theme.base0B}",
                  57 : "${self.theme.base0C}",
                  71 : "${self.theme.base0D}",
                  86 : "${self.theme.base0E}",
                  100: "${self.theme.base0F}",
                })
              ),
              // background_color: "${self.theme.base00}",
              // header_background_color: "${self.theme.base01}",
              modal_background_color: "${self.theme.base01}",
              modal_backdrop: true,
              text_color: "${self.theme.base07}",
              preview_label_style: (fg: "${self.theme.base0F}"),
              preview_metadata_group_style: (fg: "${self.theme.base09}"),
              tab_bar: (
                active_style: (fg: "${self.theme.base01}", bg: "${self.theme.base01}"),
                inactive_style: (fg: "${self.theme.base07}"),
              ),
              highlighted_item_style: (bg: "${self.theme.base00}", fg: "${self.theme.base08}"),
              current_item_style: (bg: "${self.theme.base01}", fg: "${self.theme.base0E}"),
              borders_style: (fg: "${self.theme.base03}"),
              highlight_border_style: (fg: "${self.theme.base04}"),
              song_table_format: [
                (
                  prop: (
            	kind: Group([])
                  ),
                  width: "1",
                ),
                (
                  prop: (
            	style: (fg: "${self.theme.base09}"),
                    kind: Property(Title),
                    default: (kind: Text("Unknown track"))
                  ),
                  label: "Title",
                  width: "50%",
                ),
                (
                  prop: (
            	style: (fg: "${self.theme.base0C}"),
                    kind: Property(Album),
                    default: (kind: Text("Unknown Album"))
                  ),
                  label: "Album",
                  width: "30%",
                ),
                (
                  prop: (
            	style: (fg: "${self.theme.base0D}"),
                    kind: Property(Artist),
                    default: (kind: Text("Unknown artist"))
                  ),
                  label: "Artist",
                  width: "20%",
                ),
                (
                  prop: (
            	kind: Group([])
                  ),
                  width: "1",
                ),
              ],

              components: {
                "track_deco": Split(
                  direction: Horizontal,
                  panes: [
            	(
            	  size: "100%",
            	  pane: Pane(Cava),
            	  borders: "LEFT | TOP | BOTTOM",
            	  border_symbols: Inherited(parent: Plain, bottom_left: "├", top_left: "├"),
            	  border_title: [
            	    (
            	      kind: Group([
            		(
            	    	  kind: Text(" ")
            	    	),
            		(
            	    	  kind: Text("Now playing: ")
            	    	),
            		(
            		  kind: Property(Song(Title)),
            		  style: (fg: "${self.theme.base0B}")
            		),
            		(
            	    	  kind: Text(" ")
            	    	),
            	      ]),
            	      default: (kind: Text(" No song "), style: (fg: "${self.theme.base08}"), modifiers: "Bold")
            	    ),
            	  ],
            	  border_title_alignment: Left
            	),
            	(
            	  size: "2.2r",
            	  borders: "LEFT | TOP | RIGHT | BOTTOM",
            	  border_symbols: Inherited(
            	    parent: Plain,
            	    bottom_left: "┴", top_left: "┬",
            	    bottom_right: "┤", top_right: "┤",
            	  ),
            	  pane: Pane(AlbumArt),
            	  border_title: [
            	    (
            	      kind: Group([
            		( kind: Text(" ["), style: (fg: "${self.theme.base0C}") ),
                  		(
                  		  kind: Property(Status(Elapsed)),
                  		  style: (fg: "${self.theme.base0C}")
                  		),
                  		( kind: Text("/") ),
                  		(
                  		  kind: Property(Status(Duration)),
                  		  style: (fg: "${self.theme.base0D}")
                  		),
                  		( kind: Text("] "), style: (fg: "${self.theme.base0D}") ),
            	      ]),
            	    ),
            	  ],
            	  border_title_alignment: Right
            	)
                  ]
                ),
              },

              header: (
                rows: [
                  (
            	      left: [
            	        (kind: Property(Status(StateV2(
            	         playing_label: " 󰐊", paused_label: " 󰏤", stopped_label: " 󰓛",
            	         playing_style: (fg: "${self.theme.base0B}"),
            	         paused_style: (fg: "${self.theme.base09}"),
            	         stopped_style: (fg: "${self.theme.base08}"),
            	        )))),
                  	  ( kind: Text(" | "), style: (fg: "${self.theme.base06}")),
                  	  // ( kind: Text("< "), style: (fg: "${self.theme.base0C}") ),
                  	  (
                  	    kind: Property(Status(Elapsed)),
                  	    style: (fg: "${self.theme.base0C}")
                  	  ),
                  	  ( kind: Text(" of "), style: (fg: "${self.theme.base06}")),
                  	  (
                  	    kind: Property(Status(Duration)),
                  	    style: (fg: "${self.theme.base0D}")
                  	  ),
                  	  // ( kind: Text(" >"), style: (fg: "${self.theme.base0D}") ),
            	      ],
            	      center: [
            	        (
            	          kind: Property(Song(Title)),
            	          style: (fg: "${self.theme.base0C}", modifiers: "Bold"),
            	          default: (kind: Text("No song"), style: (fg: "${self.theme.base08}"))
            	        ),
            	        ( kind: Text(" by "), style: (fg: "${self.theme.base07}") ),
            	        (
            	          kind: Property(Song(Artist)),
            	          style: (fg: "${self.theme.base0B}"),
            	          default: (kind: Text("Unknown artist"), style: (fg: "${self.theme.base09}"))
            	        ),
            	      ],
            	      right: [
            	        (kind: Property(Status(RepeatV2(on_label: "󰑖", off_label: "󰑖", on_style: (fg: "${self.theme.base08}"), on_off: (fg: "#5e6387"))))),
            	        (kind: Text(" / "), style: (fg: "${self.theme.base07}")),
            	        (kind: Property(Status(RandomV2(on_label: "󰒟", off_label: "󰒟", on_style: (fg: "${self.theme.base09}"), on_off: (fg: "#5e6387"))))),
            	        (kind: Text(" / "), style: (fg: "${self.theme.base07}")),
            	        (kind: Property(Status(SingleV2(on_label: "󰎄", off_label: "󰎄", on_style: (fg: "${self.theme.base0A}"), on_off: (fg: "#5e6387"))))),
            	        // (kind: Text(" / Vol at "), style: (fg: "${self.theme.base07}")),
            	        (kind: Text(" / "), style: (fg: "${self.theme.base07}")),
            	        (kind: Property(Status(Volume)), style: (fg: "${self.theme.base0D}")),
            	        (kind: Text("% "), style: (fg: "${self.theme.base0D}"))
            	      ],
                  )
                ]
              ),

              layout: Split(
                direction: Vertical,
                panes: [
                  (
            	size: "3",
            	borders: "ALL",
            	border_symbols: Inherited(parent: Plain, bottom_left: "├", bottom_right: "┤"),
            	pane: Pane(Tabs)
                  ),
                  (
            	size: "2",
            	borders: "BOTTOM | LEFT | RIGHT",
            	border_symbols: Inherited(parent: Plain, bottom_left: "├", bottom_right: "┤"),
            	pane: Pane(Header)
                  ),
                  (
            	size: "70%",
            	borders: "LEFT | RIGHT",
            	pane: Pane(TabContent)
                  ),
                  (
            	size: "30%",
            	pane: Component("track_deco")
                  ),
                  (
            	size: "2",
            	borders: "BOTTOM | LEFT | RIGHT",
            	pane: Pane(ProgressBar)
                  ),
                ]
              )
            )
          '';
          config = pkgs.writeTextDir "config/config.ron" ''
            #![enable(implicit_some)]
            #![enable(unwrap_newtypes)]
            #![enable(unwrap_variant_newtypes)]
            (
              scrolloff: 1,
              enable_config_hot_reload: false,
              theme: Some("${theme}/config/theme.ron"),

              cava: (
                framerate: 60,
                autosens: true,
                sensetivity: 100,
                input: (
                  method: Fifo,
                  source: "/tmp/mpd.fifo",
                  sample_rate: 44100,
                  channels: 2,
                  sample_bit: 16,
                ),
                smoothing: (
                  noise_reduction: 77,
                )
              ),
              album_art: (
                method: Kitty,
                vertical_align: Center,
                horizontal_align: Center,
              ),
              keybinds: (
                clear: true,
                global: {
                  "q": Quit,
                  "?": ShowHelp,
                  ":": CommandMode,

                  "z": ToggleRepeat,
                  "x": ToggleRandom,
                  "c": ToggleSingleOnOff,

                  "p": TogglePause,
                  "s": Stop,

                  "<": PreviousTrack,
                  ">": NextTrack,

                  "f": SeekForward,
                  "b": SeekBack,
                  "0": SeekToStart,

                  "-": VolumeDown,
                  "=": VolumeUp, // look i want both of them to do the same thing without one having shift

                  "1": SwitchToTab("Queue"),
                  "2": SwitchToTab("Artists"),
                  "3": SwitchToTab("Albums"),
                  "4": SwitchToTab("Playlists"),
                },
                navigation: {
                  "<Esc>": Close,
                  "<Enter>": Confirm,

                  "h": Left,
                  "j": Down,
                  "k": Up,
                  "l": Right,
                  "<Left>": Left,
                  "<Down>": Down,
                  "<Up>": Up,
                  "<Right>": Right,
                  "<C-u>": UpHalf,
                  "<C-d>": DownHalf,
                  "gg": Top,
                  "G": Bottom,

                  "<Space>": Select,
                  "<C-Space>": InvertSelection,

                  "K": MoveUp,
                  "J": MoveDown,

                  "/": EnterSearch,
                  "<C-n>": NextResult,
                  "<C-p>": PreviousResult,

                  "a": Add,
                  "A": AddAll,
                  "D": Delete,
                  "<C-r>": Rename,
                  "<C-z>": ContextMenu(),
                  "<C-s>": Save(kind: Modal(all: false, duplicates_strategy: Ask)),
                  "<C-D>": DeleteFromPlaylist(kind: Modal()),
                },
                queue: {
                  "d": Delete,
                  "D": DeleteAll,
                  "<Enter>": Play,
                  "C": JumpToCurrent,
                  "X": Shuffle,
                }
              ),
              tabs: [
                (
                  name: "Queue",
                  pane: Pane(Queue),
                ),
                (
                  name: "Artists",
                  pane: Pane(Artists),
                ),
                (
                  name: "Albums",
                  pane: Pane(Albums),
                ),
                (
                  name: "Playlists",
                  pane: Pane(Playlists),
                ),
              ],
            )
          '';
        in
        {
          inherit pkgs;
          package = pkgs.rmpc;
          runtimePkgs = [ pkgs.cava ];
          flags = {
            "--config" = "${config}/config/config.ron";
          };
        }
      );
    };
}
