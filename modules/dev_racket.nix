{ pkgs, lib, system, channels, bonusShellAliases, ... }: 
(if lib.strings.hasSuffix "darwin" system then { # getting racket from nix is broken on darwin
  home.sessionPath = [
      "/Applications/Racket/bin"
  ];
} else {
  home.packages = [
    pkgs.racket
  ];
})
