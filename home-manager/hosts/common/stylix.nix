{ pkgs, rootDir, ... }:
{
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
}
