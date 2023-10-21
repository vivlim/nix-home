{ pkgs, lib, system, bonusShellAliases ? {}, ... }: {
  programs.bash = {
    enable = true;
    shellOptions = [
      # Append to history file rather than replacing it.
      "histappend"

      # check the window size after each command and, if
      # necessary, update the values of LINES and COLUMNS.
      "checkwinsize"

      # Extended globbing.
      "extglob"
      "globstar"

      # Warn if closing shell with running jobs.
      "checkjobs"
    ];

    initExtra = ''
      [[ -f ~/.nix_hm/bashrc ]] && . ~/.nix_hm/bashrc
    '';

    # login shell init commands
    profileExtra = ''
      [[ -f ~/.nix_hm/bash_profile ]] && . ~/.nix_hm/bash_profile
    '';
  };
  programs.zsh = { enable = true; };

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
}
