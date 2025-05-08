{
  pkgs,
  lib,
  self,
  system,
  ...
}: {
  patternMatch = match: none: multiple: pattern: let
    isValidPattern =
      builtins.all (
        entry: (builtins.isList entry) && (builtins.length entry == 2)
      )
      pattern;
    matches = builtins.filter (entry: (builtins.elemAt entry 0) == match) pattern;
    return =
      if builtins.length matches == 1
      then builtins.elemAt (builtins.elemAt matches 0) 1
      else if builtins.length matches == 0
      then none
      else if builtins.length matches > 1
      then multiple
      else throw "Unreachable branch! Somehow a lists length was not 0, 1, or any greater number?!";
  in
    assert isValidPattern; return;

  simpleEnabledPrograms = programs:
    lib.foldl' (prevIteration: program: prevIteration // {"${program}".enable = true;}) {} programs;
  complexEnabledPrograms = config: dir: let
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
                system
                ;
            };
          }
      ) {}
      nixFiles;
  in
    programAttrs;
  simpleEnabledServices = services:
    lib.foldl' (prevIteration: service: prevIteration // {"${service}".enable = true;}) {} services;
  complexEnabledServices = config: dir: let
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
  dynamicOuts = import ./dynamic-outputs.nix {
    inherit lib;
  };
}
