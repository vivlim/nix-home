{ pkgs, lib, system, bonusShellAliases ? {}, ... }: {
  home.packages = with pkgs; [
    asciinema
  ];
}
