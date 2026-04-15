pkgs: let
  callPackage = (pkgs.extend (_: _: packages)).callPackage;
  packages = {
    hydrus-client = callPackage ./hydrus-client.nix {};
    snix-cli =
      (pkgs.callPackage "${(builtins.fetchGit {
        url = "git+https://git.snix.dev/snix/snix";
        rev = "b0a9664987faa8c9331a54cd91ea7889c71bfe64";
      })}/default.nix" {localSystem = pkgs.stdenv.system;}).snix.cli.eval;
  };
in
  packages
