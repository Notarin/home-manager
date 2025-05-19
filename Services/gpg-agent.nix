{pkgs, ...}: {
  enable = true;
  pinentry.package = pkgs.pinentry-qt;
}
