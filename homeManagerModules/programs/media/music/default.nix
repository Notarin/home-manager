{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = lib.mkIf (config.host == "uriel") [
    pkgs.pear-desktop
    pkgs.plexamp
  ];
}
