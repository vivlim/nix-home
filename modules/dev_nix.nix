{ pkgs, system, channels, bonusShellAliases, ... }: {
  home.packages = [
    pkgs.rnix-lsp
  ];
}
