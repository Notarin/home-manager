# This is the configuration that is deployed to ALL managed users.
{
  pkgs,
  lib,
  rootDir,
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
      killall
      pwvucontrol
      gnome-disk-utility
      overskride
      google-chrome
      nil
      nixfmt-rfc-style
      wine
      file-roller
      wl-clipboard
      prismlauncher
      r2modman
      packwiz
      qjackctl
      gparted
      comma
      vlc
      gimp
      element-desktop
      hydrus
    ];

    sessionVariables = {
      VISUAL = config.home.sessionVariables.EDITOR;
      NIXOS_OZONE_WL = "1";
    };
  };

  xdg.portal.config.common.default = "*";

  gtk.enable = true;
  qt.enable = true;

  wayland.windowManager.hyprland = import (rootDir + /resources/hyprland.nix) {
    inherit pkgs lib;
  };
}
