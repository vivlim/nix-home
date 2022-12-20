{ stdenv, lib, pkgs, writeScript }: 
# https://www.reddit.com/r/NixOS/comments/k3acxu/is_there_a_declarative_way_to_have_shell_scripts/ge1wpo6/
let
  screenclip = pkgs.writeShellScriptBin "screenclip" ''
    if [ -z ''${SCREENSHOT_DESTINATION+x} ]; then 
      export SCREENSHOT_DESTINATION=~/Pictures/Screenshots
    fi
    mkdir -p "$SCREENSHOT_DESTINATION"
    ${pkgs.maim}/bin/maim -s | tee "$SCREENSHOT_DESTINATION/$(date +%s).png" | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png
  '';
in stdenv.mkDerivation rec {
  name = "viv-gui-misc-scripts-${version}";
  version = "1.0.0";
  phases = "installPhase";
  
  installPhase = ''
    mkdir -p $out/bin
    cp ${screenclip}/bin/* $out/bin/
  '';
  
  meta = with lib; {
    description = "misc gui scripts";
    platforms = with platforms; linux; # linux ++ darwin if i wanted darwin;
    license = licenses.mit;
  };
}
