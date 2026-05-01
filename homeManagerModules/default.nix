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
      ./home.nix
      {
        home.username = "notarin";
        config.host = "uriel";
      }
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
