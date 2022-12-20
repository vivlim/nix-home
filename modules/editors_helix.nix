{ pkgs, ... }: 
{
  home.packages = [ pkgs.unstable.helix ];
  home.file.".config/helix".source = ./dotfiles/helix;
}
