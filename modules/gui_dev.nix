{ pkgs, system, channels, home-manager, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
}
