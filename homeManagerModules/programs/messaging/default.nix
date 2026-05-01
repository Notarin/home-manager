{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./nixcord.nix
  ];
  home.packages =
    lib.mkIf (config.host == "uriel")
    [
      (pkgs.discord.override {
        withVencord = true;
      })
      pkgs.element-desktop
      pkgs.nheko
    ];
}
