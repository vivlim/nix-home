{ pkgs, lib, system, bonusShellAliases ? {}, ... }: {
  home.packages = with pkgs; [
    htop
    fd
    fzf
    nix-prefetch
    sops
    starship
    tmate
    ripgrep
    ncdu
    p7zip
    git
    lazygit
    tldr
    wget
    jq
    xq-xml
    jless
    rnr # renamer https://github.com/ismaelgv/rnr
    yazi # file manager
    unar # unarchiver
    xkcdpass
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
  programs.atuin = {
    enable = true;
    settings = {
      update_check = false;
      prefers_reduced_motion = true;
      keymap_mode = "vim-insert"; # esc switches to 'normal' mode
      style = "auto";
      inline_height = 40;
    };
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

  home.file.".config/lazygit/config.yml".text = (builtins.toJSON {
    os = {
      editPreset = "nvim";
    };
    confirmOnQuit = true;
    quitOnTopLevelReturn = true;
    keybinding = {
      universal = {
        quit = "q"; # briefly tried setting this to <c-c> and turning off confirm, but I think I prefer having it on
      };
    };
    gui = {
      nerdFontsVersion = 3; # just guessing what version of nerd fonts I have
    };
    git = {
      disableForcePushing = true; # require force pushes to be done manually
    };
    update = {
      method = "never"; # don't check for updates
    };
    promptToReturnFromSubprocess = false;
  });

  programs.starship = {
    enable = true;
    enableBashIntegration = true; # do this ourselves in bash initExtra.
    settings = {
    };
  };

  home.shellAliases = { yless = "jless --yaml"; } // bonusShellAliases;

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
