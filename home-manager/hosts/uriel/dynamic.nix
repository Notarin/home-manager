{
  lib,
  config,
  self,
  ...
}: {
  programs =
    lib.local.complexEnabledPrograms config (./Software);
}
