{
  description = "Home Manager configuration of Notarin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nixcord.url = "github:kaylorben/nixcord";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    home-manager,
    stylix,
    treefmt-nix,
    nixcord,
    ...
  }:
    flake-utils.lib.eachDefaultSystemPassThrough (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
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
          stylix.homeManagerModules.stylix
          nixcord.homeModules.nixcord
        ];
        extraSpecialArgs = {
          inherit self system;
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
    );
}
