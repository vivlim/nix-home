{ pkgs, system, channels, bonusShellAliases, ... }: let
lazykube = pkgs.buildGoModule rec {
  pname = "lazykube";
  version = "0.10.3";
  src = pkgs.fetchFromGitHub {
    owner = "TNK-Studio";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "sha256-xfGzbjaH7dHeLWEaoRcYx5Gc3w4a4Kk1a1gG/EbXmSg=";
  };
  vendorHash = "sha256-3D+CElXHJv1WmBnO32hS4vW5VXXlNR3LwyGMtQJh3xs=";
};
in {
  home.packages = [
    pkgs.age
    pkgs.jq
    lazykube
  ];

  programs.bash = {
    initExtra = ''
      if command -v kubectl &> /dev/null
      then
        source <(kubectl completion bash)
      fi
    '';
  };
}
