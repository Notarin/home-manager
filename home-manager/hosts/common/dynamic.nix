{
  pkgs,
  lib,
  config,
  self,
  ...
}: let
  simpleEnabledPrograms = programs:
    lib.foldl' (prevIteration: program: prevIteration // {"${program}".enable = true;}) {} programs;
  complexEnabledPrograms = dir: let
    nixFiles = builtins.filter (file: lib.hasSuffix ".nix" file) (
      builtins.attrNames (builtins.readDir dir)
    );
    programAttrs =
      builtins.foldl' (
        prevIteration: file:
          prevIteration
          // {
            "${lib.removeSuffix ".nix" file}" = import (dir + "/${file}") {
              inherit
                pkgs
                lib
                config
                self
                ;
            };
          }
      ) {}
      nixFiles;
  in
    programAttrs;
  simpleEnabledServices = services:
    lib.foldl' (prevIteration: service: prevIteration // {"${service}".enable = true;}) {} services;
  complexEnabledServices = dir: let
    nixFiles = builtins.filter (file: lib.hasSuffix ".nix" file) (
      builtins.attrNames (builtins.readDir dir)
    );
    serviceAttrs =
      builtins.foldl' (
        prevIteration: file:
          prevIteration
          // {
            "${lib.removeSuffix ".nix" file}" = import (dir + "/${file}") {
              inherit
                pkgs
                lib
                config
                self
                ;
            };
          }
      ) {}
      nixFiles;
  in
    serviceAttrs;
in {
  programs =
    (simpleEnabledPrograms [
      "home-manager"
      "nh"
      "git"
      "direnv"
      "tealdeer"
      "bat"
      "cava"
      "lazygit"
      "wofi"
      "fuzzel"
      "gpg"
    ])
    // (complexEnabledPrograms (self + /Software));

  services =
    (simpleEnabledServices [
      "swaync"
    ])
    // (complexEnabledServices (self + /Services));
}
