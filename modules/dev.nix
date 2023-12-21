{ pkgs, system, channels, bonusShellAliases, ... }: {
  home.packages = with pkgs; [
    direnv
    cmake
    lua-language-server
    #bash-language-server
  ];
  programs.direnv.enable = true;
}
