{ pkgs, lib, system, bonusShellAliases ? {}, ... }: {
  home.packages = [
    pkgs.htop
    pkgs.fd
    pkgs.nix-prefetch
    pkgs.sops
    pkgs.nixfmt
    pkgs.starship
    pkgs.tmate
    pkgs.ripgrep
    pkgs.ncdu
    pkgs.p7zip
    pkgs.git
    pkgs.gitui
    pkgs.tldr
    pkgs.visidata
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
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    historyLimit = 5000;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "screen-256color";
    extraConfig = ''
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel

      # switch panes using hjkl 
      bind h select-pane -L
      bind l select-pane -R
      bind k select-pane -U
      bind j select-pane -D

      # resize 'em too
      bind -r C-h resize-pane -L 3
      bind -r C-l resize-pane -R 3
      bind -r C-k resize-pane -U 3
      bind -r C-j resize-pane -D 3

      # these make more sense to me
      bind / split-window -h
      bind - split-window -v

      bind r source-file ~/.config/tmux/tmux.conf

      # escape key reaches editors sooner
      set -s escape-time 30

      # transparent status bar
      set -g status-style bg=default

      # why have i been torturing myself with no mouse support for so long
      set -g mouse on

      # set-clipboard on allows osc52 emitted from nvim to reach the attached terminal(s)
      set -s set-clipboard on
    '';
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
      command -v starship &> /dev/null && eval "$(starship init bash)"
    '';

    # login shell init commands
    profileExtra = "";

    # bashrc init commands (run even in non-interactive shells)
    bashrcExtra = ''
      export SENTINEL=heya
    '';
  };
  programs.zsh = { enable = true; };

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
