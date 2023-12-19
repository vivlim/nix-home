{ pkgs, system, channels, bonusShellAliases, ... }: {
  home.packages = with pkgs; [
    direnv
    cmake
  ];
  programs.direnv.enable = true;
}
