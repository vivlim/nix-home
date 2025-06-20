{ pkgs, system, channels, bonusShellAliases, ... }: {
  home.packages = with pkgs; [
    direnv
    #cmake
    lua-language-server
    uv
    #bash-language-server
  ];
  programs.direnv.enable = true;
}
