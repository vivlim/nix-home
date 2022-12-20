{ pkgs, system, channels, bonusShellAliases, ... }: {
  home.packages = [ pkgs.obs-studio pkgs.ffmpeg pkgs.vlc pkgs.deadbeef pkgs.imagemagick pkgs.exiftool ];
}
