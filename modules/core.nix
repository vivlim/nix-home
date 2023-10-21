{ pkgs, lib, system, bonusShellAliases ? {}, ... }: {
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
}
