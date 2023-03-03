{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [];
      # debug = true;
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: let
        myEmacsPkg = pkgs.emacsGit.pkgs.withPackages (epkgs: (with epkgs.melpaPackages; [
          use-package
          org-roam
          org-roam-ui
          haskell-mode
          f
          no-littering
          alert
	        doom-themes
	        dashboard
	        org-modern
	        epkgs.elpaPackages.vertico
	        no-littering
	        marginalia
	        orderless
	        beacon
	        all-the-icons
	        # org-roam-dailies
	        org-roam-ui
	        epkgs.elpaPackages.corfu
	        keycast
	        nix-mode
	        magit
	        ob-mongo

          ]));
          myEmacs = pkgs.writeShellScriptBin "emacs-wrapper" ''
              ${myEmacsPkg}/bin/emacs "$@"
          '';
      in
        {
          _module.args.pkgs = import inputs.nixpkgs { inherit system; overlays = [ inputs.emacs-overlay.overlay ]; };
              
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ myEmacs ];
          };
          packages.default = throw "use the devshell: nix develop -c emacs-wrapper --init-directory=.";
        };

      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      };
    };
}
