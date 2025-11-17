{
  lib,
  writeScriptBin,
  nushell,
}: let
  preprocessedScript = builtins.readFile ./nix-repl.nu;
  shebang = "#!${lib.getExe nushell}";
  processedScript = "${shebang}\n${preprocessedScript}";
in
  writeScriptBin "nix-repl" processedScript
