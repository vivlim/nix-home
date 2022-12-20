{ pkgs, system, channels, nixGL, ... }: 

let
  # this didn't work but i used it to trace once
  # nixglnvidia = builtins.trace (nixGL)  nixGL.packages.x86_64-linux.nixGLNvidia;#{ nvidiaVersion = "470.141.03"; };
in

   {
  home.packages = [
    nixGL.packages.x86_64-linux.nixGLNvidia
    pkgs.glxinfo # test tools, not needed
  ];
  
  home.shellAliases = {
    nixGL = "$HOME/.nix-profile/bin/nixGLNvidia*"; # lol.
  };
}
