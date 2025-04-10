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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      ...
    }@inputs:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ ];
      };

      lib = inputs.nixpkgs.lib;

      usersDir = ./home-manager/users;
      removeNixSuffix = raw_name: lib.removeSuffix ".nix" raw_name;
      getPathString =
        { location, fileName }:
        lib.strings.concatStrings [
          (builtins.toString location)
          "/"
          fileName
        ];
      getPath =
        { location, fileName }:
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
      hosts = builtins.map (host: {
        hostName = host;
        configPath = /. + "${builtins.toString hostsDir}/${host}/home.nix";
      }) hostsRaw;

      common = ./home-manager/hosts/common/home.nix;
      commonModules = [
        common
        stylix.homeManagerModules.stylix
      ];

      extraSpecialArgs = {
        rootDir = self;
      };
    in
    {
      homeConfigurations = builtins.listToAttrs (
        builtins.concatMap (
          user:
          builtins.concatMap (host: [
            {
              name = "${user.userName}@${host.hostName}";
              value = home-manager.lib.homeManagerConfiguration {
                inherit pkgs extraSpecialArgs;
                modules = commonModules ++ [ host.configPath ];
              };
            }
          ]) hosts
        ) users
        ++ builtins.map (user: {
          name = "${user.userName}";
          value = home-manager.lib.homeManagerConfiguration {
            inherit pkgs extraSpecialArgs;
            modules = commonModules ++ [ user.configPath ];
          };
        }) users
      );
    };
}
