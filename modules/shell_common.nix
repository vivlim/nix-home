{ pkgs, lib, system, bonusShellAliases ? {}, ... }: {
  home.packages = with pkgs; [
    htop
    fd
    nix-prefetch
    sops
    starship
    tmate
    ripgrep
    ncdu
    p7zip
    git
    gitui
    tldr
    wget
    jq
  ];
  programs.git = {
    enable = true;
    userName = "vivlim";
    userEmail = "vivlim@vivl.im";
    extraConfig = {
      pull = {
        rebase = false;
      };
    };
  };
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

  };
  home.file.".nix_hm/bashrc" = {
    text = ''
      if [ x"''${STARSHIP_SUPPRESS}" == "x" ]; then
        command -v starship &> /dev/null && eval "$(starship init bash)"
      fi
      command -v direnv &> /dev/null && eval "$(direnv hook bash)"
    '';
  };
  home.file.".nix_hm/bash_profile" = {
    text = ''
      # include .profile-mac if it exists
      [[ -f ~/.profile-mac ]] && . ~/.profile-mac

      export SENTINEL=heya

      # not sure why this is missing on some machines, but it shouldn't hurt to add it
      export PATH=$HOME/.nix-profile/bin:$PATH
    '';
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true; # do this ourselves in bash initExtra.
    settings = {
    };
  };

  home.shellAliases = { sentinel = "echo $SENTINEL"; } // bonusShellAliases;

  # fsr my tmux config freezes tmate
  # home.file.".tmate.conf".text = ''
  #   source-file ~/.config/tmux/tmux.conf  
  # '';

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];

  home.sessionVariables = { LESS = "--mouse --wheel-lines=3 --RAW-CONTROL-CHARS"; };
}
