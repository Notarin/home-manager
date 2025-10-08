{
  pkgs,
  self,
  ...
}: {
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/chalk.yaml";
    image = self + /Images/Horizontal_WP.png;
    fonts = rec {
      monospace = {
        name = "FiraCode Nerd Font";
        package = pkgs.nerd-fonts.fira-code;
      };
      serif = monospace;
      sansSerif = monospace;
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
    targets.vscode.profileNames = ["default"];
    targets.qt.enable = true; # For whatever reason, this must be explicitly enabled.
    targets.firefox = {
      colorTheme.enable = true;
      profileNames = ["default"];
    };
  };
  i18n.inputMethod = {
    enable = false;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [fcitx5-mozc];
      waylandFrontend = true;
    };
  };
}
