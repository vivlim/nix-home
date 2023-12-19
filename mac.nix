{ pkgs, home-manager, ... }:
{
  home.packages = with pkgs; [ emacs28NativeComp bash ];
  home.sessionPath = [
    "$HOME/.emacs.d/bin" # doom emacs
  ];

  home.activation = {
    linkLazygitConfig = home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ -f ~/Library/Application\ Support/lazygit/config.yml ]; then
        echo "~/Library/Application\ Support/lazygit/config.yml exists already"
      else
        echo "linking ~/Library/Application\ Support/lazygit/config.yml to ~/.config/lazygit/config.yml"
        ln -s ~/.config/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml
      fi
    '';
  };
}
