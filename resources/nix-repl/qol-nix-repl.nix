{
  pkgs,
  lib,
  ...
}: let
  commonConfig = {shellAliases."nix repl" = lib.getExe (pkgs.callPackage ./package.nix {});};
in {
  programs.bash = commonConfig;
  programs.zsh = commonConfig;
  programs.fish = commonConfig;
  programs.nushell = commonConfig;
}
