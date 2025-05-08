{lib, ...}: {
  removeNixSuffix = raw_name: lib.removeSuffix ".nix" raw_name;
  getPathString = {
    location,
    fileName,
  }:
    lib.strings.concatStrings [
      (builtins.toString location)
      "/"
      fileName
    ];
  getPath = {
    location,
    fileName,
  }:
    /.
    + (lib.local.dynamicOuts.getPathString {
      inherit location;
      inherit fileName;
    });

  usersRaw = usersDir: builtins.attrNames (builtins.readDir usersDir);
  parseRawUsers = usersDir:
    builtins.map (rawUser: {
      userName = lib.local.dynamicOuts.removeNixSuffix rawUser;
      configPath = lib.local.dynamicOuts.getPath {
        location = usersDir;
        fileName = rawUser;
      };
    });

  hostsRaw = hostsDir:
    builtins.filter (host: host != "common") (
      builtins.attrNames (builtins.readDir hostsDir)
    );
}
