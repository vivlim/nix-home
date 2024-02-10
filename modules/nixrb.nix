pkgs: let 
  myLuaEnv = pkgs.lua5_2.withPackages (ps: with ps; [ ]);
  in {
  viv-nixrb = pkgs.writeShellScriptBin "nixrb" ''
    ${myLuaEnv.out}/bin/lua ${../lua/nixrb.lua} -- $@
  '';
}
