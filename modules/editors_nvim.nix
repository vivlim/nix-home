{ pkgs, home-manager, ... }: let
  
  use_cloned_nvim_config_snippet = ''
    use-cloned-nvim-config-if-available () {
      if [[ -e $HOME/git/vimfiles/launch.sh ]]; then
        $HOME/git/vimfiles/launch.sh $@
      else
        ${pkgs.neovim}/bin/nvim $@
      fi
    }

    alias nvim="use-cloned-nvim-config-if-available"
  '';
in {
  home.packages = [ pkgs.neovim pkgs.neovim-remote ];

  home.file.".config/nvim-ro".source = pkgs.fetchFromGitHub {
    owner = "vivlim";
    repo = "vimfiles";
    rev =
      "b0b05f4edec8b970cb584ffc65f5b281f6b5e6f3"; # #! ./_get_ref_commithash https://github.com/vivlim/vimfiles neovim
    sha256 =
      "sha256-x02zFHEqNl9MiiKoHfkgKcS+4x2DHlP7VeqHD0VVKy0="; # #! ./_get_github_sha256 vivlim vimfiles neovim
  };

  home.sessionVariables = { EDITOR = "nvim"; };

  home.activation = {
    linkNeovimConfig = home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ -d ~/.config/nvim ]; then
        echo "~/.config/nvim exists already"
      else
        echo "linking ~/.config/nvim to ~/.config/nvim-ro"
        ln -s ~/.config/nvim-ro ~/.config/nvim
      fi
    '';
  };

  programs.bash.initExtra = use_cloned_nvim_config_snippet;
  programs.zsh.initExtra = use_cloned_nvim_config_snippet;
}
