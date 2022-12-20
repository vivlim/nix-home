{ pkgs, system, channels, nixGL, ... }: 

let
in

   {
  home.packages = [
    nixGL.packages.x86_64-linux.nixGLIntel
    pkgs.glxinfo # test tools, not needed
  ];
  
  home.shellAliases = {
    nixGL = "$HOME/.nix-profile/bin/nixGLIntel*"; # lol.
  };
}
