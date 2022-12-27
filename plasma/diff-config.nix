{lib, ...}:
let
  recFilter = (import ../lib/recFilter.nix {inherit lib; traceRecFilter = true;});
  config = (import ./plasma-manager-config.nix);
  base = (import ./plasma-manager-config-base.nix);
in
  #recFilter config base
  recFilter 
  {
    a = "a";
    b = "b";
    c = "c'";
    d = "d";
    e = "e'";
  }
  {
    a = "a";
    b = "b";
    c = "c";
    d = "d";
    e = "e";
  }

