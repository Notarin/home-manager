{
  self,
  caelestia,
  lib,
  ...
}: {
  home.file.".config/caelestia" = {
    source = self + "/resources/caelestia/";
  };
  wayland.windowManager.hyprland.settings.exec-once = [
    (lib.getExe caelestia.default)
  ];
}
