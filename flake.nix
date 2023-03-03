{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [];
      # debug = true;
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages.default = let
          myEmacsPkg = pkgs.emacs.pkgs.withPackages (epkgs: (with epkgs.melpaPackages; [
            use-package
            org-roam
            org-roam-ui
            haskell-mode
          ]));
          myEmacs = pkgs.writeShellScriptBin "emacs-wrapper" ''
              ${myEmacsPkg}/bin/emacs -q --load emacs/init.el
          '';
        in myEmacs;
    };

      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      };
    };
}
