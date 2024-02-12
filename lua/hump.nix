{ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "hump";
  version = "0.4-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/hump-0.4-2.rockspec";
    sha256 = "0j89rznvq90bvjsj1mj9plxmxj8c7b4jkqsllw882f8xscdqq2sa";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON '' '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://hump.readthedocs.io";
    description = "Lightweight game development utilities";
    license.fullName = "MIT";
  };
}
