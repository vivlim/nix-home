{ pkgs, lib, system, channels, bonusShellAliases, ... }: {
  home.packages = [
    pkgs.xonsh-with-env
  ];
}
