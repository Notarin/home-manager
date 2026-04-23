pkgs: let
  callPackage = (pkgs.extend (_: _: packages)).callPackage;
  packages = {
    hydrus-client = callPackage ./hydrus-client.nix {};
    snix-cli = callPackage ./snix.nix {};
  };
in {
  inherit (packages) hydrus-client snix-cli;
}
