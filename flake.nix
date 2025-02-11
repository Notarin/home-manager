{
  description = "Home Manager configuration of Notarin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { nixpkgs,
    home-manager,
    stylix,
    ...
  }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."notarin" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ./home.nix
          stylix.homeManagerModules.stylix
        ];
      };
    };
}
