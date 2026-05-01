{
  pkgs,
  lib,
  config,
  self,
  ...
}: {
  home.packages = lib.mkIf (config.host == "uriel") [
    self.packages.${pkgs.stdenv.system}.hydrus-client
    pkgs.gimp
    pkgs.plex-htpc
  ];
}
