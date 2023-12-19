{ pkgs, ... }:
{
  home.packages = with pkgs; [ emacs28NativeComp bash ];
  home.sessionPath = [
    "$HOME/.emacs.d/bin" # doom emacs
  ];
}
