{ pkgs, lib, system, bonusShellAliases ? {}, ... }: {
  home.packages = with pkgs; [
    htop
    fd
    nix-prefetch
    sops
    nixfmt
    starship
    tmate
    ripgrep
    ncdu
    p7zip
    git
    gitui
    tldr
    visidata
    nushell
    pueue
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

    # interactive shell init commands
    initExtra = ''
      if [ x"$\{STARSHIP_SUPPRESS\}" == "x" ]; then
        command -v starship &> /dev/null && eval "$(starship init bash)"
      fi
    '';

    # login shell init commands
    profileExtra = ''
      # include .profile-mac if it exists
      [[ -f ~/.profile-mac ]] && . ~/.profile-mac
    '';

    # bashrc init commands (run even in non-interactive shells)
    bashrcExtra = ''
      export SENTINEL=heya

      # not sure why this is missing on some machines, but it shouldn't hurt to add it
      export PATH=$HOME/.nix-profile/bin:$PATH
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

  nix = {
    package = pkgs.nixStable;
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };

  home.file.".config/nixpkgs/config.nix".text = ''
    {
      nixpkgs.config.allowUnfree = true;
    }
  '';

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.cargo/bin"
  ];

  home.sessionVariables = { LESS = "--mouse --wheel-lines=3 --RAW-CONTROL-CHARS"; };
}
