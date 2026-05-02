{
  pkgs,
  lib,
  self,
  config,
  ...
}: {
  imports = [
    ./bash.nix
    ./btop.nix
    ./carapace.nix
    ./lazygit.nix
    ./nushell.nix
    ./shellAliases.nix
    ./starship.nix
    ./zellij.nix
    ./zoxide.nix
    ./zsh.nix
  ];
  home.packages =
    [
      pkgs.comma
      pkgs.gomuks
    ]
    ++ lib.optional (config.host == "uriel") self.packages.${pkgs.stdenv.system}.snix-cli;
  programs = {
    nh.enable = true;
    git.enable = true;
    direnv.enable = true;
    tealdeer.enable = true;
    bat.enable = true;
  };
}
