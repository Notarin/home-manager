{
  description = "Home Manager configuration of Notarin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snix = {
      url = "git+https://git.snix.dev/snix/snix";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-vscode-extensions,
    snix,
    ...
  }: let
    systems = ["x86_64-linux"];
    buildEachSystem = output: builtins.map (system: output system) systems;
    buildAllSystems = output: (builtins.foldl' (acc: elem: nixpkgs.lib.recursiveUpdate acc elem) {} (buildEachSystem output));
  in (buildAllSystems (
    system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          trusted-public-keys = [
            "cache.snix.dev-1:miTqzIzmCbX/DyK2tLNXDROk77CbbvcRdWA4y2F8pno="
          ];
          substituters = [
            "https://cache.snix.dev"
          ];
        };
        overlays = [
          nix-vscode-extensions.overlays.default
        ];
      };
      lib = pkgs.lib.extend (
        prev: final:
          {
            local = import ./Functions/main.nix {
              inherit
                pkgs
                lib
                self
                system
                ;
            };
          }
          // home-manager.lib
      );
    in {
      formatter.${system} = pkgs.callPackage ./format.nix {};
      checks.${system}.formatting = self.formatter.${system};
      devShells.${system}.default = pkgs.mkShell {
        shellHook = ''
          oldHookDir=$(git config --local core.hooksPath)

          if [ "$oldHookDir" != "$PWD/.githooks" ]; then
            read -rp "Set git hooks to $PWD/.githooks? (y/n) " answer
            if [ "$answer" = "y" ]; then
              git config core.hooksPath "$PWD"/.githooks
              echo "Set git hooks to $PWD/.githooks"
            else
              echo "Skipping git hooks setup"
            fi
          fi
        '';
      };
      packages.${system} = {
        hydrus-client = pkgs.symlinkJoin {
          name = "hydrus-client";
          paths = [
            (pkgs.writeShellScriptBin "hydrus-client" ''
              env --unset=WAYLAND_DISPLAY ${lib.getExe' pkgs.hydrus "hydrus-client"}
            '')
            pkgs.hydrus
          ];
        };
        snix-cli = (pkgs.callPackage "${snix}/default.nix" {localSystem = system;}).snix.cli.eval;
      };
      homeConfigurations = import ./homeManagerModules {inherit pkgs lib self;};
    }
  ));
}
