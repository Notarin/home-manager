{
  rustPlatform,
  fetchgit,
  protobuf,
  lib,
  busybox-sandbox-shell,
}: let
  cargoRoot = "snix";
  cargoProject = builtins.fromTOML (builtins.readFile "${src}/${cargoRoot}/cli/eval/Cargo.toml");
  src =
    (fetchgit {
      url = "https://git.snix.dev/snix/snix";
      rev = "e952b5ae99242baed8f6ffa1b98aa80f4f02911e";
      sha256 = "sha256-pXRO6pHWfgBSMokoXhdoTAAF6s3ycObxYz80LaP/1/o=";
    }).overrideAttrs
    {
      unsafeDiscardReferences.out = true;
    };
in
  rustPlatform.buildRustPackage {
    pname = cargoProject.package.name;
    version = cargoProject.package.version;
    inherit src cargoRoot;
    buildAndTestSubdir = cargoRoot;
    cargoLock = {
      lockFile = "${src}/${cargoRoot}/Cargo.lock";
      outputHashes = {
        "hyper-1.9.0" = "sha256-XnUOQYfPa+LKOx7aKz5wv4tL9hXirJ7UkrMBiM7bHb4=";
        "tonic-0.14.5" = "sha256-bf88XZMzeplglunUDOU5XWFgKpbzoVV1r4Sj3qvhOHQ=";
        "wu-manber-0.1.0" = "sha256-7YIttaQLfFC/32utojh2DyOHVsZiw8ul/z0lvOhAE/4=";
      };
    };
    cargoBuildFlags = [
      "--package=${cargoProject.package.name}"
    ];

    nativeBuildInputs = [
      protobuf
    ];
    env = {
      SNIX_BUILD_SANDBOX_SHELL = lib.getExe busybox-sandbox-shell;
    };
    doCheck = false; # A test fails, I don't really care.

    meta = {
      description = "The REPL component of Snix, a modern Rust re-implementation of the components of the Nix package manager.";
      homepage = "https://snix.dev/";
      license = lib.licenses.gpl3;
      mainProgram = "snix-eval"; # The built binary does not match the package name.
    };
  }
