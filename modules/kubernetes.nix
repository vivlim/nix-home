{ pkgs, system, channels, bonusShellAliases, ... }: {
  home.packages = [
    pkgs.age
    pkgs.jq
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
