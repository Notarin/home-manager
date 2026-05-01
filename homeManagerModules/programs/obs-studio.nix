{pkgs, ...}: {
  programs.obs-studio = {
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vkcapture
      obs-vaapi
      obs-tuna
      obs-pipewire-audio-capture
    ];
  };
}
