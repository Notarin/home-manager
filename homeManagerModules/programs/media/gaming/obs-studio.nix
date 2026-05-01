{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.obs-studio = {
    enable = lib.mkIf (config.host == "uriel") true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vkcapture
      obs-vaapi
      obs-tuna
      obs-pipewire-audio-capture
    ];
  };
}
