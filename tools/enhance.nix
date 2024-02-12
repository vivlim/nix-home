{ pkgs, ...} : {

  enhance = pkgs.writeShellScriptBin "enhance" ''
  export TARGET=$(nix-store -q --requisites $1 | ${pkgs.fzf}/bin/fzf)
  find $TARGET -type f | ${pkgs.fzf}/bin/fzf \
    --ansi \
    --preview-window up,1,border-horizontal \
    --preview '${pkgs.bat}/bin/bat --color=always {}'\
    --bind 'enter:become(vim {1})'
'';
}
