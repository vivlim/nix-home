{ pkgs, lib, system, channels, bonusShellAliases, ... }: 
{
  home.packages = [
    pkgs.toot # mastodon cli
  ];
}
