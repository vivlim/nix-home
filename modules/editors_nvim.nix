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
  home.packages = [ pkgs.neovim ];

  home.file.".config/nvim-ro".source = pkgs.fetchFromGitHub {
    owner = "vivlim";
    repo = "vimfiles";
    rev =
      "99bdfe77c15cfc34a01772fe6829dede221e1b21"; # #! ./_get_ref_commithash https://github.com/vivlim/vimfiles neovim
    sha256 =
      "sha256-PlBdNYsv6BRMPrHyJ/neD7ZUCuUZfCQJUKJwuZuc2o0="; # #! ./_get_github_sha256 vivlim vimfiles neovim
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
