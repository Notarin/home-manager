{
  lib,
  pkgs,
  config,
  ...
}: {
  programs.btop = {
    enable = true;
    package = lib.mkIf (config.host == "uriel") pkgs.btop-rocm;
    settings = {
      update_ms = 100;
    };
  };
}
