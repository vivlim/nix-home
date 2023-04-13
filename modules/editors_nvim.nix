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
      "c7a9dda14645bec82688338c64e6494fb3aebdaf"; # #! ./_get_ref_commithash https://github.com/vivlim/vimfiles neovim
    sha256 =
      "sha256-HQcpcglHEy02TyzcBYMt7yyTTZpbSMamzi1mVJSRvCU="; # #! ./_get_github_sha256 vivlim vimfiles neovim
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
