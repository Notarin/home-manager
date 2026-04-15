{
  pkgs,
  lib,
  config,
  self,
  ...
}: let
  globalShellConfig = import (self + "/resources/shellConfig.nix") {inherit lib config pkgs;};
in {
  programs.zsh =
    lib.recursiveUpdate {
      enable = true;
      sessionVariables = config.home.sessionVariables;
    }
    globalShellConfig;
}
