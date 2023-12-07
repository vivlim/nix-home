{ pkgs, system, channels, bonusShellAliases, ... }: {
  home.packages = [
    pkgs.direnv
  ];
  programs.direnv.enable = true;
}
