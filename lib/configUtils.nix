{ ... }: {
  squishConfigFiles = files: builtins.toString (builtins.map (f: builtins.readFile f) files);
}
