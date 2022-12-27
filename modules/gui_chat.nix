{ pkgs, system, channels, home-manager, ... }: {
  home.packages = [ pkgs.unstable.element-desktop pkgs.unstable.discord ];
}
