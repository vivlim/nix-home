{ pkgs, system, channels, bonusShellAliases, ... }: {
  home.packages = [ pkgs.unstable.element-desktop pkgs.unstable.discord ];
}
