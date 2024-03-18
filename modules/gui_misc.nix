{ pkgs, channels, bonusShellAliases, ... }: {
  nixpkgs.config.packageOverrides = pkgs: rec {
      viv-gui-misc-scripts = pkgs.callPackage ./gui_misc_scripts.nix {} ;
  };

  home.packages = with pkgs; [
    maim
    xclip
    viv-gui-misc-scripts
    #duc # disk usage scanner # commented out because I indexed with a gentoo build, which uses a different backend.
  ];

  #home.sessionVariables = { SCREENSHOT_DESTINATION = "~/Pictures/Screenshots"; };
}
