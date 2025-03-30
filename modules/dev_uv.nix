{ pkgs, system, channels, bonusShellAliases, ... }: {
  # uv needs to run in a FHS env because it downloads python and runs it.
  home.packages = let
    uvWrapped = (pkgs.buildFHSEnv {
      name = "uv";
      runScript = "${pkgs.uv}/bin/uv";
    });
  in [
    uvWrapped
  ];
}
