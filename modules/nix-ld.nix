{ pkgs, system, channels, bonusShellAliases, ... }: {
# Tools for running binaries built for other distros on nixos.
# https://unix.stackexchange.com/questions/522822/different-methods-to-run-a-non-nixos-executable-on-nixos
# https://github.com/Mic92/nix-ld
# https://github.com/nix-community/nix-ld-rs/
  home.packages = [ pkgs.nix-ld-rs ];
}
