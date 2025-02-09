{
  description = "Home Manager configuration of Notarin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # dots resources
    wezterm-config = {
      url = "github:Notarin/wezterm-config";
      flake = false;
    };
    starship-config = {
      url = "github:Notarin/starship-config";
      flake = false;
    };
    neovim-config = {
      url = "github:Notarin/neovim-config";
      flake = false;
    };
    nushell-config = {
      url = "github:Notarin/nushell-config";
      flake = false;
    };
    hyprland-config = {
      url = "github:Notarin/hyprland-config";
      flake = false;
    };
    helix-config = {
      url = "github:Notarin/helix-config";
      flake = false;
    };
    zsh-config = {
      url = "github:Notarin/zsh-config";
      flake = false;
    };
    ssh-config = {
      url = "github:Notarin/ssh-config";
      flake = false;
    };
  };

  outputs = { nixpkgs,
    home-manager,
    wezterm-config,
    starship-config,
    neovim-config,
    nushell-config,
    hyprland-config,
    helix-config,
    zsh-config,
    ssh-config,
    ...
  }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."notarin" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit wezterm-config;
          inherit starship-config;
          inherit neovim-config;
          inherit nushell-config;
          inherit hyprland-config;
          inherit helix-config;
          inherit zsh-config;
          inherit ssh-config;
        };
        modules = [ ./home.nix ];
      };
    };
}
