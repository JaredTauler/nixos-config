{
  config,
  lib,
  pkgs,
  ...
}: let
  # vscode-js-debug and dap-node act funny together. maybe can be fixed in lisp
  jsDebugWrapped = pkgs.writeShellScriptBin "js-debug-wrapped" ''
    echo "js-debug-wrapped starting" >&2
    sleep 3
    exec ${pkgs.vscode-js-debug}/bin/js-debug "$@" 127.0.0.1
  '';
in {
  services.emacs = {
    enable = true;
    socketActivation.enable = true;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
    #       # (setq dap-js-debug-program '("${jsDebugWrapped}/bin/js-debug-wrapped"))
    extraConfig = ''
      (setq
      dap-js-path "${pkgs.vscode-js-debug}/bin"
      dap-js-debug-program '("${pkgs.vscode-js-debug}/bin/js-debug"))
    '';
    extraPackages = epkgs:
      with epkgs; [
        direnv
        envrc
        magit
        evil

        lsp-mode
        lsp-ui
        tree-sitter
        tree-sitter-langs

        cape
        corfu
        orderless

        #projectile
        consult
        vertico
        which-key
        marginalia
        general # hotkeys

        flycheck

        nix-mode

        # lisp
        slime

        mmm-mode

        polymode # TODO

        dap-mode
        markdown-mode
        pdf-tools
        vterm
        yaml-mode
        web-mode
        json-mode
        typescript-mode
        emacsql

        org

        modus-themes
        catppuccin-theme
        ef-themes

        # texliveFull
      ];
  };

  # environment.sessionVariables.TREE_SITTER_LIB_PATH =
  #   pkgs.lib.makeSearchPathOutput "lib" "lib" (with pkgs.tree-sitter-grammars; [
  #     tree-sitter-c
  #     tree-sitter-cpp
  #     tree-sitter-json
  #     tree-sitter-python
  #     tree-sitter-typescript
  #     tree-sitter-tsx
  #     tree-sitter-javascript
  #     tree-sitter-nix
  #     tree-sitter-bash
  #     tree-sitter-yaml
  #     tree-sitter-markdown
  #   ]);

  # FIXME naughty
  home.file.".emacs.d/init.el".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixos-config/home-option/emacs/dotfiles/init.el";

  home.packages = with pkgs; [
    # Document editing
    pandoc
    texliveFull

    # Nix
    nixd
    # nixfmt-rfc-style
    # nixfmt
    alejandra
    statix

    # Webdev

    nodejs_20
    html-tidy
    nodePackages.typescript
    nodePackages.typescript-language-server

    git
    gcc
    gnumake
    cmake
    libtool

    python3
    direnv

    vscode-js-debug
  ];

  # For direnv
  services.lorri.enable = true;
}
