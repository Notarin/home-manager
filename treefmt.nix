{pkgs, ...}: {
  projectRootFile = ".git/config";
  settings = {
    allow-missing-formatter = false;
  };
  programs = {
    alejandra = {
      enable = true;
      package = pkgs.alejandra;
    };
    stylua = {
      enable = true;
      package = pkgs.stylua;
    };
  };
}
