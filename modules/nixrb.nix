{pkgs, nixpkgsFlake, luarocks-nix}: let 
  extraLuaRocks = pkgs.lib.attrsets.mapAttrs' (name: type: {name = pkgs.lib.strings.removeSuffix ".nix" name; value = (../. + "/luarocks/${name}");}) (builtins.readDir ../luarocks);

  myLuaEnv = pkgs.lua5_2.withPackages (ps: let 
    ps2 = ps // (builtins.mapAttrs (name: pkgfn: (pkgs.callPackage pkgfn ps2)) extraLuaRocks);
  in with ps2; [ luarepl linenoise (builtins.break croissant) ]);

  luaLib = with pkgs; (callPackage "${nixpkgsFlake.outPath}/pkgs/development/lua-modules/lib.nix" { });
  buildLuarocksPackage = with pkgs; (callPackage "${nixpkgsFlake.outPath}/pkgs/development/interpreters/lua-5/build-luarocks-package.nix" { inherit luaLib;});
  in {
  viv-nixrb = pkgs.writeShellScriptBin "nixrb" ''
    ${myLuaEnv.out}/bin/lua ${../lua/nixrb.lua} -- $@
  '';
  rep-lua = pkgs.writeShellScriptBin "rep.lua" ''
    cd ${myLuaEnv.out}
    sh
    ${myLuaEnv.out}/bin/lua ${../lua/rep.lua} -- $@
  '';
  luarocks-nix = pkgs.writeShellScriptBin "luarocks-nix" ''
    # shell script that writes a luarock nix to the working directory and adds it to git
    export PATH=$PATH:${pkgs.nix-prefetch-git}/bin

    if [[ "$PWD" == *luarocks ]]; then
      ${luarocks-nix.packages.x86_64-linux.luarocks-52}/bin/luarocks nix $1 > $1.nix
      # Need to patch the resulting file so that it accepts arguments other than those it cares about.
      ${pkgs.gnused}/bin/sed -i 's/}:$/, ... }:/' $1.nix
      git add $1.nix
      echo "wrote to and git added $1.nix"
    else
      echo "not in a dir with a name ending in luarocks, just writing to stdout." >&2
      ${luarocks-nix.packages.x86_64-linux.luarocks-52}/bin/luarocks nix $1
    fi
  '';
  }
