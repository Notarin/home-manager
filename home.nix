{
  config,
  pkgs,
  wezterm-config,
  nushell-config,
  ssh-config,
  inputs,
  ...
}:

{
  # System specific
  home.username = "notarin";
  home.homeDirectory = "/home/notarin";
  # Do not touch
  home.stateVersion = "24.05";

  # Packages
  home.packages = with pkgs; [
    killall
  ];

  # Deployed files/directories
  home.file = {
    ".config/wezterm/".source = wezterm-config;
    ".config/nushell/".source = nushell-config;
    ".config/nushell/".recursive = true;
    ".ssh/".source = ssh-config;
    ".ssh/".recursive = true;
  };

  # ENV variables
  home.sessionVariables = {
    EDITOR = "hx";
  };

  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-soft.yaml";
  stylix.image = ./Images/Horizontal_WP.png;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    settings = import ./hyprland-settings.nix;
  };
  gtk.enable = true;
  qt.enable = true;
  programs.btop.enable = true;
  programs.btop.settings.update_ms = 100;
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      hostname = {
        ssh_symbol = "📡";
      };
      shell = {
        disabled = false;
      };
    };
  };
  programs.helix.enable = true;

  # Allow home-manager to update itself
  programs.home-manager.enable = true;
}
