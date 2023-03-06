{ pkgs, ... }:
{
  home.packages = [ pkgs.emacs28NativeComp ];
  home.sessionPath = [
    "$HOME/.emacs.d/bin" # doom emacs
  ];
}
