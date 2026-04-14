{
  self,
  pkgs,
  lib,
}: {
  notarin = self.inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs lib;
    extraSpecialArgs = {inherit self;};
    modules = [
      ./home.nix
      ./notarin.nix
    ];
  };
  "notarin@uriel" = self.inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs lib;
    extraSpecialArgs = {inherit self;};
    modules = [
      ./home.nix
      ./notarin.nix
      ./uriel/home.nix
    ];
  };
  root = self.inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs lib;
    extraSpecialArgs = {inherit self;};
    modules = [
      ./home.nix
      ./root.nix
    ];
  };
}
