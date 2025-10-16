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
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
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
    stylix,
    treefmt-nix,
    nixcord,
    nix-vscode-extensions,
    snix,
    ...
  }: let
    systems = ["x86_64-linux"];
    buildEachSystem = output: builtins.map (system: output system) systems;
    buildAllSystems = output: (
      builtins.foldl' (acc: elem: nixpkgs.lib.recursiveUpdate acc elem) {} (buildEachSystem output)
    );
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
      lib = pkgs.lib.extend (prev: final:
        {
          local = import ./Functions/main.nix {
            inherit pkgs lib self system;
          };
        }
        // home-manager.lib);
      treefmt-config = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

      usersDir = ./home-manager/users;
      users = (lib.local.dynamicOuts.parseRawUsers usersDir) (lib.local.dynamicOuts.usersRaw usersDir);

      hostsDir = ./home-manager/hosts;
      hosts =
        builtins.map (host: {
          hostName = host;
          configPath = /. + "${builtins.toString hostsDir}/${host}/home.nix";
        })
        (lib.local.dynamicOuts.hostsRaw hostsDir);

      commonModules = [
        ./home-manager/hosts/common/home.nix
        stylix.homeModules.stylix
        nixcord.homeModules.nixcord
      ];
      extraSpecialArgs = {
        inherit self system snix;
      };
    in {
      formatter.${system} = treefmt-config.config.build.wrapper;
      checks.${system}.formatting = treefmt-config.config.build.check self;
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
            (
              pkgs.writeShellScriptBin
              "hydrus-client"
              ''
                env --unset=WAYLAND_DISPLAY ${lib.getExe' pkgs.hydrus "hydrus-client"}
              ''
            )
            pkgs.hydrus
          ];
        };
      };
      homeConfigurations = builtins.listToAttrs (
        builtins.concatMap (
          user:
            builtins.concatMap (host: [
              {
                name = "${user.userName}@${host.hostName}";
                value = home-manager.lib.homeManagerConfiguration {
                  inherit pkgs lib extraSpecialArgs;
                  modules =
                    commonModules
                    ++ [
                      host.configPath
                      user.configPath
                    ];
                };
              }
            ])
            hosts
        )
        users
        ++ builtins.map (user: {
          name = "${user.userName}";
          value = home-manager.lib.homeManagerConfiguration {
            inherit pkgs lib extraSpecialArgs;
            modules = commonModules ++ [user.configPath];
          };
        })
        users
      );
    }
  ));
}
