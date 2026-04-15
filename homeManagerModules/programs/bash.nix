{
  pkgs,
  lib,
  config,
  self,
  ...
}: let
  globalShellConfig = import (self + "/resources/shellConfig.nix") {inherit lib config pkgs;};
in {
  programs.bash = (
    lib.recursiveUpdate {
      enable = true;
      sessionVariables = config.home.sessionVariables;
    }
    globalShellConfig
  );
}
