{lib, ...}: {
  options.host = lib.mkOption {
    type = with lib.types; enum ["" "uriel"];
    apply = lib.toLower;
    default = "";
    example = "uriel";
    description = "The optional hostname, for optional host-specific configuration.";
  };
}
