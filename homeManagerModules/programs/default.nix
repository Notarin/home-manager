{pkgs, ...}: {
  imports = [
    ./editor
    ./media
    ./messaging
    ./shell
    ./wezterm
    ./firefox.nix
    ./hyprland.nix
  ];
  programs.gpg.enable = true;
  home.packages = [pkgs.bitwarden-desktop];
}
