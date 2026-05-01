{
  config,
  lib,
  ...
}: {
  home.username = lib.mkDefault "notarin";
  home.homeDirectory =
    if config.home.username == "notarin"
    then "/home/notarin"
    else if config.home.username == "root"
    then "/root"
    else throw "Unhandled user, please define their home in user.nix";
  home.stateVersion = "26.05";
}
