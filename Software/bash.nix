{
  lib,
  config,
  self,
  ...
} @ specialArgs: let
  globalShellConfig = import (self + "/resources/shellConfig.nix") specialArgs;
in
  lib.recursiveUpdate {
    enable = true;
    sessionVariables = config.home.sessionVariables;
  }
  globalShellConfig
