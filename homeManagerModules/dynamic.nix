{
  lib,
  config,
  self,
  ...
}: {
  programs = lib.local.complexEnabledPrograms config (self + /Software);
  services = lib.local.complexEnabledServices config (self + /Services);
}
