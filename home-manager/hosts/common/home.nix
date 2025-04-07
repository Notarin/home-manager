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
      EDITOR = "hx";
      NIXOS_OZONE_WL = "1";
    };
  };

  xdg.portal.config.common.default = "*";

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-soft.yaml";
    image = rootDir + /Images/Horizontal_WP.png;
    fonts.monospace = {
      name = "Fira Code";
      package = pkgs.fira-code;
    };
    cursor = {
      package = pkgs.oreo-cursors-plus;
      name = "oreo_pink_cursors";
      size = 32;
    };
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
    targets.vscode.profileNames = [ "default" ];
    targets.qt.enable = true; # For whatever reason, this must be explicitly enabled.
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [ fcitx5-mozc ];
      waylandFrontend = true;
    };
  };

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
