{ pkgs, system, channels, bonusShellAliases, ... }: {
  programs.vscode = {
    enable = true;
    # needed for rust lang server and rust-analyzer extension
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ rustup zlib openssl.dev pkg-config ]);
  };

  # unfree as in unfreedom
  nixpkgs.config.allowUnfree = true;
}
