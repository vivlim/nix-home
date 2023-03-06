{ pkgs, system, channels, bonusShellAliases, ... }: {
  home.packages = with pkgs; [
    obs-studio
    ffmpeg
    vlc
    deadbeef
    imagemagick
    exiftool
    gimp
    inkscape
    audacity
  ];
}
