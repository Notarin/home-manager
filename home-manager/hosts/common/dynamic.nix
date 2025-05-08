{
  lib,
  config,
  self,
  ...
}: {
  programs =
    (lib.local.simpleEnabledPrograms [
      "home-manager"
      "nh"
      "git"
      "direnv"
      "tealdeer"
      "bat"
      "cava"
      "lazygit"
      "wofi"
      "fuzzel"
      "gpg"
    ])
    // (lib.local.complexEnabledPrograms config (self + /Software));

  services =
    (lib.local.simpleEnabledServices [
      "swaync"
    ])
    // (lib.local.complexEnabledServices config (self + /Services));
}
