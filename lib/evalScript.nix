{ pkgs, name, expr, ... }:
let
  exprFile = builtins.toFile "${name}.expr.nix" expr;
  script = pkgs.writeShellScriptBin name ''
    #nix eval --impure --inputs-from ${../.} --no-update-lock-file -f ${exprFile}
    nix repl --quiet --impure <<EOF
    :lf ${../.}
    ${expr}
    EOF
  '';
in pkgs.stdenv.mkDerivation {
  name = "evalScript-${name}";
  version = "1.0.0";
  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp ${script}/bin/${name} $out/bin/
  '';

  meta = with pkgs.lib; {
    description = "nix eval script for ${name}";
    platforms = with platforms; linux;
    license = licenses.mit;
  };
}

