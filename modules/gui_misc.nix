{ pkgs, channels, bonusShellAliases, ... }: {
  nixpkgs.config.packageOverrides = pkgs: rec {
      viv-gui-misc-scripts = pkgs.callPackage ./gui_misc_scripts.nix {} ;
  };

  home.packages = with pkgs; [ maim xclip viv-gui-misc-scripts ];

  #home.sessionVariables = { SCREENSHOT_DESTINATION = "~/Pictures/Screenshots"; };
}
