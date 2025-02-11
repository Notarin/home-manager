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

    # dots resources
    wezterm-config = {
      url = "github:Notarin/wezterm-config";
      flake = false;
    };
    nushell-config = {
      url = "github:Notarin/nushell-config";
      flake = false;
    };
  };

  outputs = { nixpkgs,
    home-manager,
    wezterm-config,
    nushell-config,
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
          inherit wezterm-config;
          inherit nushell-config;
          inherit inputs;
        };
        modules = [
          ./home.nix
          stylix.homeManagerModules.stylix
        ];
      };
    };
}
