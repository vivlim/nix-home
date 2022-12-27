{ pkgs, system, channels, bonusShellAliases, ... }: {
  home.packages = [ pkgs.unstable.blender-hip pkgs.inkscape pkgs.gimp pkgs.krita ];
}
