{
  lib,
  config,
  ...
}: {
  programs.mangohud = {
    enable = lib.mkIf (config.host == "uriel") true;
    settings = {
      round_corners = 6;
      position = "top-right";
    };
  };
}
