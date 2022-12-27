{ pkgs, channels, bonusShellAliases, ... }: let 
  autostartScript = pkgs.writeShellScriptBin "ksshaskpass-autostart" ''
    ssh-add
  '';
in {
  xdg.desktopEntries.ksshaskpass-autostart = {
    name = "ksshaskpass autostart";
    exec = "${autostartScript}/bin/ksshaskpass-autostart";
    terminal = false;
    categories = [ "Network" ];
    #noDisplay = true;
  };

  home.packages = with pkgs; [ ark kate xdotool pavucontrol
  (import ../lib/evalScript.nix {
    inherit pkgs;
    name = "nixhome-update-plasma-cfg";
    expr = ''
      let
        rf = (import ${../lib/recFilter.nix} { lib = inputs.nixpkgs.lib; traceRecFilter = false; });
      in
        rf (import ${./plasma-manager-config.nix}) (import ${./plasma-manager-config-base.nix})
    '';
    })];

  
}
