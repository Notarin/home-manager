{
  symlinkJoin,
  makeWrapper,
  hydrus,
}:
symlinkJoin {
  name = "hydrus-client";
  nativeBuildInputs = [makeWrapper];
  paths = [hydrus];
  postBuild = ''
    wrapProgram $out/bin/hydrus-client --unset WAYLAND_DISPLAY
  '';
}
