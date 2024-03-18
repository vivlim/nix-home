{ pkgs, system, channels, bonusShellAliases, ... }: {
  home.packages = [
    pkgs.nix-prefetch-github
    pkgs.git-crypt
    pkgs.nixfmt
  ];
}
