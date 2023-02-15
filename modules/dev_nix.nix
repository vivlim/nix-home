{ pkgs, system, channels, bonusShellAliases, ... }: {
  home.packages = [
    pkgs.rnix-lsp
    pkgs.nix-prefetch-github
    pkgs.git-crypt
  ];
}
