{ pkgs, lib, system, channels, bonusShellAliases, ... }: 
{
  home.packages = [
    pkgs.bemoji # emoji picker
  ];
}
