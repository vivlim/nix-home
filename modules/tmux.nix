{ pkgs, lib, system, bonusShellAliases ? {}, ... }: let
  configUtils = import ../lib/configUtils.nix {};
in {
  home.packages = [
    pkgs.tmux
  ];
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    historyLimit = 5000;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "screen-256color";
    extraConfig = configUtils.squishConfigFiles [
      ./dotfiles/tmux/bindings.conf
      ./dotfiles/tmux/clipboard_osc52.conf
      ./dotfiles/tmux/mouse.conf
      ./dotfiles/tmux/style_basic.conf
    ];
  };
}
