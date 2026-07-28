{pkgs, ...}: {
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      extra-experimental-features = "nix-command flakes";
    };
  };
  nixpkgs.config = {
    allowUnfree = true;
    microsoftVisualStudioLicenseAccepted = true;
    vivaldi = {
      proprietaryCodecs = true;
      enableWideVine = true;
    };
    permittedInsecurePackages = [
      "olm-3.2.16"
      "electron-39.8.10"
    ];
  };
}
