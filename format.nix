{
  treefmt-nix ?
    import (
      builtins.fetchGit {
        url = "https://github.com/numtide/treefmt-nix";
        rev = "790751ff7fd3801feeaf96d7dc416a8d581265ba";
      }
    ),
  lib,
  writeShellScriptBin,
  formats,
  treefmt,
  alejandra,
  stylua,
}:
treefmt-nix.mkWrapper
{
  inherit
    lib
    writeShellScriptBin
    treefmt
    formats
    alejandra
    stylua
    ;
}
{
  projectRootFile = ".git/config";
  settings = {
    allow-missing-formatter = false;
  };
  programs = {
    alejandra.enable = true;
    stylua.enable = true;
  };
}
