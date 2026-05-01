{
  self,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [self.inputs.nixcord.homeModules.nixcord];
  programs.nixcord.vesktop.enable = lib.mkIf (config.host == "uriel") true;
  home.packages =
    lib.mkIf (config.host == "uriel")
    [
      pkgs.vesktop
    ];
}
