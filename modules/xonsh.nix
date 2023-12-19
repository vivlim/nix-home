{ pkgs, lib, system, channels, bonusShellAliases, ... }: let

  # ugh. need to factor this differently
  nixrbScript = pkgs.writeShellScriptBin "nixrb" ''
    ${bonusShellAliases.nixrb}
  '';
in {
  home.packages = [
    pkgs.xonsh-with-env
  ];
  home.file.".config/xonsh/rc.d/nix_hm.xsh".text = ''
    from xonsh.built_ins import XSH
    xontrib load direnv
    XSH.env["PATH"].append("${nixrbScript}/bin")
    XSH.env["PATH"].append("~/.cargo/bin")
    XSH.env["PATH"].append("~/.local/bin")
    XSH.env["PATH"].append("~/bin")
    XSH.aliases["yless"] = ["jless", "--yaml"]
  '';
}
