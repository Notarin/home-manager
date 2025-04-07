# This is the configuration that is deployed to ALL managed users.
{
  pkgs,
  lib,
  rootDir,
  config,
  ...
}:

let
  simpleEnabledPrograms =
    programs:
    lib.foldl' (prevIteration: program: prevIteration // { "${program}".enable = true; }) { } programs;
  complexEnabledPrograms =
    dir:
    let
      nixFiles = builtins.filter (file: lib.hasSuffix ".nix" file) (
        builtins.attrNames (builtins.readDir dir)
      );
      programAttrs = builtins.foldl' (
        prevIteration: file:
        prevIteration
        // {
          "${lib.removeSuffix ".nix" file}" = import (dir + "/${file}") {
            inherit
              pkgs
              lib
              config
              rootDir
              ;
          };
        }
      ) { } nixFiles;
    in
    programAttrs;
in
{
  imports = [
    ./stylix.nix
  ];

  home = {
    packages = with pkgs; [
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
      vesktop
      jetbrains.rust-rover
      prismlauncher
      r2modman
      packwiz
      qjackctl
    ];

    # Files that are symlinked to the home directory
    file = { };

    sessionVariables = {
      VISUAL = config.home.sessionVariables.EDITOR;
      NIXOS_OZONE_WL = "1";
    };
  };

  xdg.portal.config.common.default = "*";

  gtk.enable = true;
  qt.enable = true;

  programs =
    (simpleEnabledPrograms [
      "home-manager"
      "nh"
      "git"
      "direnv"
      "tealdeer"
      "bat"
      "cava"
      "gitui"
      "wofi"
      "fuzzel"
    ])
    // (complexEnabledPrograms (rootDir + /Software));

  services.swaync.enable = true;

  wayland.windowManager.hyprland = import (rootDir + /resources/hyprland.nix) {
    inherit pkgs lib;
  };

  # Nix settings
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      extra-experimental-features = "nix-command flakes";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
