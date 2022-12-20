{ pkgs, system, channels, bonusShellAliases, nil, ... }: {
  home.packages = [ nil.packages.${system}.nil ];
}
