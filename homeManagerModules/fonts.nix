{pkgs, ...}: {
  home.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.dejavu_fonts
    pkgs.jetbrains-mono
  ];
  fonts.fontconfig.enable = true;
  stylix.fonts = rec {
    monospace = {
      name = "FiraCode Nerd Font";
      package = pkgs.nerd-fonts.fira-code;
    };
    serif = monospace;
    sansSerif = monospace;
  };
}
