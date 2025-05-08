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
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    home-manager,
    stylix,
    treefmt-nix,
    ...
  }:
    flake-utils.lib.eachDefaultSystemPassThrough (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        treefmt-config = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

        usersDir = ./home-manager/users;
        removeNixSuffix = raw_name: nixpkgs.lib.removeSuffix ".nix" raw_name;
        getPathString = {
          location,
          fileName,
        }:
          nixpkgs.lib.strings.concatStrings [
            (builtins.toString location)
            "/"
            fileName
          ];
        getPath = {
          location,
          fileName,
        }:
          /.
          + (getPathString {
            inherit location;
            inherit fileName;
          });
        usersRaw = builtins.attrNames (builtins.readDir usersDir);
        parseRawUsers = builtins.map (rawUser: {
          userName = removeNixSuffix rawUser;
          configPath = getPath {
            location = usersDir;
            fileName = rawUser;
          };
        });
        users = parseRawUsers usersRaw;

        hostsDir = ./home-manager/hosts;
        hostsRaw = builtins.filter (host: host != "common") (
          builtins.attrNames (builtins.readDir hostsDir)
        );
        hosts =
          builtins.map (host: {
            hostName = host;
            configPath = /. + "${builtins.toString hostsDir}/${host}/home.nix";
          })
          hostsRaw;

        common = ./home-manager/hosts/common/home.nix;
        commonModules = [
          common
          stylix.homeManagerModules.stylix
        ];
        extraSpecialArgs = {
          inherit self;
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
                    inherit pkgs extraSpecialArgs;
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
              inherit pkgs extraSpecialArgs;
              modules = commonModules ++ [user.configPath];
            };
          })
          users
        );
      }
    );
}
