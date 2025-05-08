# This is the configuration that is deployed to ALL managed users.
{
  pkgs,
  lib,
  self,
  config,
  ...
}: {
  imports = [
    ./nix.nix
    ./stylix.nix
    ./dynamic.nix
  ];

  home = {
    packages = with pkgs; [
      (discord.override {
        withVencord = true;
      })
      vesktop
      pwvucontrol
      gnome-disk-utility
      overskride
      google-chrome
      wine
      file-roller
      wl-clipboard
      prismlauncher
      r2modman
      qjackctl
      comma
      vlc
      gimp
      element-desktop
    ];

    sessionVariables = {
      VISUAL = config.home.sessionVariables.EDITOR;
      NIXOS_OZONE_WL = "1";
    };
  };

  xdg.portal.config.common.default = "*";

  gtk.enable = true;
  qt.enable = true;

  wayland.windowManager.hyprland = import (self + /resources/hyprland.nix) {
    inherit pkgs lib;
  };
}
