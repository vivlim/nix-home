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
      "5f6ce38d993e5e6e8d23d52f24e3cae9d206dd7e"; # #! ./_get_ref_commithash https://github.com/vivlim/vimfiles neovim
    sha256 =
      "sha256-zrPVuogUd161N34T0+N5eoTi5yfzJJyfHLTvs6+AFZM="; # #! ./_get_github_sha256 vivlim vimfiles neovim
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
