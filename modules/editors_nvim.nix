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

  home.file.".config/nvim".source = pkgs.fetchFromGitHub {
    owner = "vivlim";
    repo = "vimfiles";
    rev =
      "a7cde6286723f42f540c03f5e87acf106d440551"; # #! ./_get_ref_commithash https://github.com/vivlim/vimfiles neovim
    sha256 =
      "sha256-DtBnzXjiFn5T9DbQuR5OJgl2lYutWJ6UwUOSFfS2Faw="; # #! ./_get_github_sha256 vivlim vimfiles neovim
  };

  home.sessionVariables = { EDITOR = "nvim"; };

  home.activation = {
    installNeovimPlugins = home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${pkgs.neovim}/bin/nvim +PlugInstall +qall
    '';
  };

  programs.bash.initExtra = use_cloned_nvim_config_snippet;
  programs.zsh.initExtra = use_cloned_nvim_config_snippet;
}
