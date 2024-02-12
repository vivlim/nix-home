{ pkgs, ...} : let

  in pkgs.stdenv.writeShellScriptBin "enhance" ''
  "nix-store -q --requisites result | fzf | xargs -I 'FILENAME' find FILENAME -type f | fzf"
'';
