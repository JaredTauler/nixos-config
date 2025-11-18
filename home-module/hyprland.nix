{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkOption mkIf;
in {
  options.my.hyprland = {
    enable = mkEnableOption "Enable my Hyprland setup";
    sources = mkOption {
      type = types.listOf types.string;
      default = [
        # TODO
        # "/home/jared/nixos-config/home-module/hyprland.conf"
      ];
      description = "Extra Hyprland config fragments";
    };
  };

  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.hyprshell.homeModules.hyprshell
  ];

  config = lib.mkIf config.my.hyprland.enable (
    let
      system = pkgs.stdenv.hostPlatform.system;

      # FIXME how make this conditional only when hyprland enabled
      # Build hyprshell with latest rust
      pkgsWithRust = import inputs.nixpkgs {
        system = system;
        overlays = [inputs.rust-overlay.overlays.default];
      };

      rustNightly = pkgsWithRust.rust-bin.nightly.latest.default;
      # hyprshellNightly =
      #   inputs.hyprshell.packages.${system}.hyprshell.override {
      #     rustPlatform = pkgsWithRust.makeRustPlatform {
      #       cargo = rustNightly;
      #       rustc = rustNightly;
      #     };
      #   };
    in {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false;
        plugins = with pkgs.hyprlandPlugins; [
          hyprsplit
          hyprspace
          borders-plus-plus
        ];

        settings = {
          "$mod" = "SUPER";
          bind = [
            # "$mod, F, exec, firefox"
            # ", Print, exec, grimblast copy area"
            # "bind = SUPER, 1, split:workspace, 1"
            #
          ];

          source = (
            ["/home/jared/nixos-config/home-module/hyprland.conf"] ++ config.my.hyprland.sources
          );
        };
      };

      # xdg.portal = {
      #   enable = true;
      #   # hyprland is the backend you want in charge
      #   extraPortals = [
      #     pkgs.xdg-desktop-portal-gtk  # for file pickers
      #     pkgs.xdg-desktop-portal-hyprland
      #   ];
      #   config = {
      #     common = {
      #       default = "hyprland";
      #     };
      #   };
      # };

      # nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

      # https://github.com/vfosnar/nix-colors-adapters
      colorScheme = inputs.nix-colors.colorSchemes.dracula;
      # TODO set hyprland theme match this
      # TODO look at themes
      # TODO GTK4 not workin
      # TODO emacs.

      programs.kitty = {
        enable = true;
        settings = {
          foreground = "#${config.colorScheme.palette.base05}";
          background = "#${config.colorScheme.palette.base00}";
          # ...
        };
      };

      home.packages = with pkgs; [
        # xdg-desktop-portal
        # xdg-desktop-portal-gtk
        # xdg-desktop-portal-hyprland

        inputs.hyprsession.packages.${pkgs.system}.hyprsession

        grim # For flameshot
        wlr-layout-ui # For changing monitor config
        pavucontrol # For sound

        jq
        slurp
        swappy
        wl-clipboard

        

        # Core KIO framework (implements file:// URIs)
        # kde.kio

        # Optional extras: thumbnailers, smb, sftp, mtp, etc.
        #kde.kio-extras
      ];

      programs.wofi = {
        enable = true;
        settings = {
          width = 500;
          height = 300;
          always_parse_args = true;
          show_all = false;
          print_command = true;
          insensitive = true;
        };
        style = ''
          window {
          margin: 5px;
          background-color: #${config.colorScheme.palette.base00};
          opacity: 1.0;
          font-size: 15px;
          font-family: JetBrainsMonoNL NF;
          border-radius: 10px;
          border: 5px solid #${config.colorScheme.palette.base03};
          }

          #outer-box {
          margin: 5px;
          border: 5px;
          border-radius: 10px;
          }

          #input {
          margin: 5px;
          background-color: #${config.colorScheme.palette.base01};
          color: #${config.colorScheme.palette.base05};
          font-size: 15px;
          border: 5px;
          border-radius: 10px;
          }

          #inner-box {
          background-color: #${config.colorScheme.palette.base00};
          border: 5px;
          border-radius: 10px;
          }

          #scroll {
          font-size: 15px;
          color: #${config.colorScheme.palette.base0F};
          margin: 10px;
          border-radius: 5px;
          }

          #scroll label {
          margin: 0px 0px;
          }

          #entry {
          margin: 5px;
          background-color: #${config.colorScheme.palette.base01};
          border-radius: 10px;
          border: 5px;
          }
          #entry:selected {
          background-color: #${config.colorScheme.palette.base02};
          border: 5px solid #${config.colorScheme.palette.base03};
          border-radius: 10px;
          border: 5px;
          }

          #img {
          margin: 5px;
          border-radius: 5px;
          }

          #text {
          margin: 2px;
          border: none;
          color: #${config.colorScheme.palette.base05};
          }
        '';
      };

      # https://mynixos.com/home-manager/options/programs.waybar
      programs.waybar = {
        enable = true; # TODO does this enable it same way systmd command thing does?
        # style = ''
        #   ${builtins.readFile ./waybar.conf}
        # '';
        # style = ''

        # '';
      };

      # https://mynixos.com/home-manager/option/services.hypridle.settings
      services.hypridle = {
        enable = true;
        settings = {
          listener = [
            # {
            #   timeout = 900;
            #   # on-timeout = "hyprlock";
            # }
            {
              timeout = 300;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };

      # Https://github.com/jtheoof/swappy
      # TODO pull request one thing with moving too fast
      home.file.".config/swappy/config".text = builtins.concatStringsSep "\n" [
        "[Default]"
        "save_dir=${config.home.homeDirectory}/Pictures/Screenshots"
        "save_filename_format=%Y%m%d-%H%M%S.png"
        "show_panel=true" # Start with brushes and stuff open
        "line_size=5"
        "text_size=20"
        "text_font=sans-serif"
        "paint_mode=brush"
        "early_exit=true" # Exit on save
        "fill_shape=false"
        "auto_save=false"
        "custom_color=rgba(0,0,0,1)"
      ];

      programs.hyprshell = {
        # package = hyprshellNightly;
        enable = true;
        systemd.args = "-v";
        settings = {
          windows = {
            enable = true; # please dont forget to enable windows if you want to use overview or switch
            overview = {
              enable = true;
              key = "super_l";
              modifier = "super";
              launcher = {
                max_items = 6;
              };
            };
            switch.enable = true;
          };
        };
      };
    }
  );
}
