{
  self,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [self.inputs.nixcord.homeModules.nixcord];
  config = lib.mkIf (config.host == "uriel") {
    programs.nixcord.vesktop.enable = true;
    home.packages = [
      pkgs.vesktop
    ];
  };
}
