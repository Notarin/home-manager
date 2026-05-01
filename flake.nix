{
  description = "Home Manager configuration for Notarin";

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
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    systems = ["x86_64-linux"];
    buildAllSystems = output: builtins.foldl' nixpkgs.lib.recursiveUpdate {} (map output systems);
  in
    buildAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        formatter.${system} = pkgs.callPackage ./formatter.nix {};
        checks.${system}.formatting = self.formatter.${system};
        packages.${system} = import ./packages pkgs;
        homeConfigurations = {
          notarin = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {inherit self;};
            modules = [./homeManagerModules];
          };
          "notarin@uriel" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {inherit self;};
            modules = [
              ./homeManagerModules
              {config.host = "uriel";}
            ];
          };
          root = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {inherit self;};
            modules = [
              ./homeManagerModules
              {home.username = "root";}
            ];
          };
        };
      }
    );
}
