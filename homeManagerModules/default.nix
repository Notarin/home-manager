{
  self,
  pkgs,
}: {
  notarin = self.inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {inherit self;};
    modules = [
      ./home.nix
      {home.username = "notarin";}
    ];
  };
  "notarin@uriel" = self.inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {inherit self;};
    modules = [
      ./uriel.nix
      {home.username = "notarin";}
    ];
  };
  root = self.inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {inherit self;};
    modules = [
      ./home.nix
      {home.username = "root";}
    ];
  };
}
