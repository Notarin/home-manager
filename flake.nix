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
    snix,
    ...
  }: let
    systems = ["x86_64-linux"];
    buildAllSystems = output: builtins.foldl' nixpkgs.lib.recursiveUpdate {} (builtins.map output systems);
  in
    buildAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            trusted-public-keys = ["cache.snix.dev-1:miTqzIzmCbX/DyK2tLNXDROk77CbbvcRdWA4y2F8pno="];
            substituters = ["https://cache.snix.dev"];
          };
        };
      in {
        formatter.${system} = pkgs.callPackage ./format.nix {};
        checks.${system}.formatting = self.formatter.${system};
        packages.${system} = {
          hydrus-client = pkgs.callPackage ./packages/hydrus-client.nix {};
          snix-cli = (pkgs.callPackage "${snix}/default.nix" {localSystem = system;}).snix.cli.eval;
        };
        homeConfigurations = import ./homeManagerModules {inherit pkgs self;};
      }
    );
}
