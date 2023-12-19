pkgs: {
  xonsh-with-env = pkgs.xonsh.override {
    extraPackages = ps: [
      (ps.buildPythonPackage
      rec {
        name = "xonsh-direnv";
        version = "1.6.1";

        src = pkgs.fetchFromGitHub {
          owner = "74th";
          repo = "${name}";
          rev = "${version}";
          sha256 = "sha256-979y+jUKZkdIyXx4q0f92jX/crFr9LDrA/5hfXm1CpU=";
        };

        meta = {
          homepage = "https://github.com/74th/xonsh-direnv";
          description = "direnv for xonsh";
          license = pkgs.lib.licenses.mit;
          maintainers = [ ];
        };
      })
    ];

  };
}
