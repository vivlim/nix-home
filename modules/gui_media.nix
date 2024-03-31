{ pkgs, lib, config, system, channels, bonusShellAliases, ... }:
let
  cfg = config.usePatchedVlc;
  vlc = let
    patchedVlc = pkgs.vlc.overrideAttrs (old: rec {
      # workaround https://www.reddit.com/r/VLC/comments/17sprje/comment/kaljwmo/?utm_source=reddit&utm_medium=web2x&context=3
      patches = old.patches ++ [
        (pkgs.fetchpatch {
          url =
            "https://code.videolan.org/videolan/vlc/-/commit/795b1bc62be58ee1636c1fac28330d02bc0e08e0.patch";
          hash = "sha256-JQRlOpJd8D28H3UZy0CTquMfN4zBJuOq2eczdX/5+Oo=";
        })
      ];
      # ref: scraps I didn't use
      #version = "3.0.21";
      #src = pkgs.fetchgit {
      #  url = "https://code.videolan.org/videolan/vlc.git";
      #  rev =  "9e296fb6f395a3f0a8afbe922705c9c4902ba58c";
      #  hash = "sha256-tWq8VMM+3s+77J/j5Yk1lUfBq1Yfxnn4oYdjCpjpClo=";
      #};
      #configureFlags = old.configureFlags ++ ["-Werror=implicit-function-declaration"]; # not this, it isn't a ./configure flag.
      #NIX_CFLAGS_COMPILE = "-Werror=implicit-function-declaration"; # whyyyy
    });
  in
  # select the right one to use according to config
  lib.mkMerge [ (lib.mkIf cfg patchedVlc) (lib.mkIf (!cfg) pkgs.vlc) ];
in {
  options.usePatchedVlc = lib.mkOption {
    type = lib.types.bool;
    description =
      "whether to use a patched version of vlc as a workaround for very wide subtitles";
    default = false;
  };
  config.home.packages = with pkgs; [
    #obs-studio
    ffmpeg
    deadbeef
    vlc
    imagemagick
    exiftool
    gimp
    inkscape
    audacity
  ];
}
