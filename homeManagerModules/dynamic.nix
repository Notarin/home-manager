{
  lib,
  config,
  self,
  ...
}: {
  services = lib.local.complexEnabledServices config (self + /Services);
}
