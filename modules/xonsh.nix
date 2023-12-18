{ pkgs, lib, system, channels, bonusShellAliases, ... }: {
  home.packages = [
    pkgs.xonsh-with-env
  ];
  home.file.".config/xonsh/rc.d/nix_hm.xsh".text = ''
    xontrib load direnv
  '';
}
