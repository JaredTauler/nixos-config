{ inputs
, lib
, config
, pkgs
, ...
}:
let

  # Build hyprshell with latest rust
  pkgsWithRust = import inputs.nixpkgs {
    system   = pkgs.system;
    overlays = [ inputs.rust-overlay.overlays.default ];
  };

  rustNightly = pkgsWithRust.rust-bin.nightly.latest.default;

  hyprshellNightly =
    inputs.hyprshell.packages.${pkgs.system}.hyprshell.override {
      rustPlatform = pkgs.makeRustPlatform {
        cargo = rustNightly;
        rustc = rustNightly;
      };
    };


  # Build flameshot to work with wl-roots compositor
  flameshotGrim = pkgs.flameshot.overrideAttrs (oldAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "flameshot-org";
      repo = "flameshot";
      rev = "3d21e4967b68e9ce80fb2238857aa1bf12c7b905";
      sha256 = "sha256-OLRtF/yjHDN+sIbgilBZ6sBZ3FO6K533kFC1L2peugc=";
    };
    cmakeFlags = [
      "-DUSE_WAYLAND_CLIPBOARD=1"
      "-DUSE_WAYLAND_GRIM=1"
    ];
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.libsForQt5.kguiaddons ];
  });


  nix-colors = inputs."nix-colors";     # <- quotes are mandatory

in
{
  imports = [
    nix-colors.homeManagerModules.default
    inputs.hyprshell.homeModules.hyprshell
  ];

  # https://github.com/vfosnar/nix-colors-adapters
  colorScheme = nix-colors.colorSchemes.dracula;
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

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    plugins = [
      pkgs.hyprlandPlugins.hyprsplit
      pkgs.hyprlandPlugins.hyprspace
    ];

    settings = {
      "$mod" = "SUPER";
      bind =
        [

          # "$mod, F, exec, firefox"
          # ", Print, exec, grimblast copy area"
          # "bind = SUPER, 1, split:workspace, 1"
          #

        ];

      source = "~/nixos-config/home-option/hyprland.conf";
    };
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
          timeout = 300 ;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };




  services.flameshot = {
    enable = true;
    package = flameshotGrim;
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
     package = hyprshellNightly;
    enable = true;
    systemd.args = "-v";
    settings = {
      launcher = {
        max_items = 6;
        plugins.websearch = {
            enable = true;
            engines = [{
                name = "DuckDuckGo";
                url = "https://duckduckgo.com/?q=%s";
                key = "d";
            }];
        };
      };

    };
   };


}
