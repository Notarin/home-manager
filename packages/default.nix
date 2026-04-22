pkgs: let
  callPackage = (pkgs.extend (_: _: packages)).callPackage;
  packages = {
    hydrus-client = callPackage ./hydrus-client.nix {};
    # TODO: Discovered an issue where snixs binary isn't in the expected location, thus cannot run from Nix CLI.
    snix-cli =
      (pkgs.callPackage "${(pkgs.fetchgit {
        url = "https://git.snix.dev/snix/snix";
        rev = "b0a9664987faa8c9331a54cd91ea7889c71bfe64";
        sha256 = "sha256-YEjXDFFITuLVnGWNFD7KfBpmCvlBh6d2jp6YiPvM1Rs=";
      })}" {localSystem = pkgs.stdenv.system;}).snix.cli.eval;
  };
in {
  inherit (packages) hydrus-client snix-cli;
}
