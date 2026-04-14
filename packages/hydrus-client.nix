{
  lib,
  symlinkJoin,
  writeShellScriptBin,
  hydrus,
}:
symlinkJoin {
  name = "hydrus-client";
  paths = [
    (writeShellScriptBin "hydrus-client" ''
      env --unset=WAYLAND_DISPLAY ${lib.getExe' hydrus "hydrus-client"}
    '')
    hydrus
  ];
}
