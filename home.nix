{ config, pkgs, ... }:

{
  # System specific
  home.username = "notarin";
  home.homeDirectory = "/home/notarin";
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Packages
  home.packages = [
  ];

  # Deployed files/directories
  home.file = {
  };

  # ENV variables
  home.sessionVariables = {
    EDITOR = "hx";
  };

  # Allow home-manager to update itself
  programs.home-manager.enable = true;
}
