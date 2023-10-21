{ pkgs, system, channels, bonusShellAliases, ... }: {
  # stuff I'm just trying out and not committed to
  home.packages = with pkgs; [
    visidata
    nushell
    pueue
  ];
}
