{
  description = "viv config bundle";
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/release-23.05"; };
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    (flake-utils.lib.eachSystem (flake-utils.lib.defaultSystems ++ ["powerpc64le-linux"]) (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      let 
        
        #nixhome-flake = import ../flake.nix;
        #nixhome-outputs = nixhome-flake.outputs {
        #  inherit nixpkgs;
        #  inherit flake-utils;
        #};
        nixhome-outputs = builtins.getFlake "/home/vivlim/git/nix-home";
        entryScript = configName: let
          config = nixhome-outputs.homeConfigurations."${configName}".config;

        in pkgs.writeShellScriptBin "entry" ''
          . ${config}
        '';
      in
      {
        defaultPackage = let
        stub = pkgs.writeShellScriptBin "stub" ''
          >&2 echo "stub $0 called with $@"
        '';
        ap = nixhome-outputs.homeConfigurations."vivlim@server".activationPackage;
        activationRunner = pkgs.stdenv.mkDerivation {
          name = "activationRunner";
          phases = "installPhase";
          installPhase = ''
            mkdir -p $out/home
            mkdir -p $out/home/.local/state/nix/profiles
            mkdir -p $out/home/.local/state/home-manager
            mkdir $out/stubs
            ln -s ${stub}/bin/stub $out/stubs/nix
            ln -s ${stub}/bin/stub $out/stubs/nix-env
            ln -s ${stub}/bin/stub $out/stubs/nix-build
            ln -s ${stub}/bin/stub $out/stubs/nix-store
            PATH=$out/stubs:$PATH
            export HOME=$out/home
            export USER=vivlim
            # patch out home dir check :)
            cat ${ap}/activate | ${pkgs.gnugrep}/bin/grep -Ev "checkHomeDirectory.*vivlim" > $out/activationScript-patched
            chmod +x $out/activationScript-patched
            ${pkgs.gnused}/bin/sed -i -e "s,export PATH=\",export PATH=\"$out/stubs:," $out/activationScript-patched
            VERBOSE=yep $out/activationScript-patched
          '';
        };
        in pkgs.writeShellScriptBin "env" ''
        export IDK=${activationRunner}
        export PATH=${ap}/home-path/bin:$PATH
        '';

        apps.repl = flake-utils.lib.mkApp {
                drv = pkgs.writeShellScriptBin "repl" ''
                  confnix=$(mktemp)
                  echo "builtins.getFlake (toString $(git rev-parse --show-toplevel))" >$confnix
                  trap "rm $confnix" EXIT
                  nix repl $confnix
                '';
              };
      }));
}
