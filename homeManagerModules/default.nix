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
      {home.username = "notarin";}
    ];
  };
  "notarin@uriel" = self.inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs lib;
    extraSpecialArgs = {inherit self;};
    modules = [
      ./home.nix
      {home.username = "notarin";}
      ./uriel/home.nix
    ];
  };
  root = self.inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs lib;
    extraSpecialArgs = {inherit self;};
    modules = [
      ./home.nix
      {home.username = "root";}
    ];
  };
}
