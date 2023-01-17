{
  description = "viv configs";
  # initial inspo: https://gitlab.com/rprospero/dotfiles/-/blob/master/flake.nix
  # many iterations happened since 🙃

  inputs = { # update a single input; nix flake lock --update-input unstable
    nixpkgs = { url = "github:NixOS/nixpkgs/release-22.05"; };
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-vivlim.url = "github:vivlim/nixpkgs/mastodon-fixes-on-unstable";
    #nixpkgs-vivlim.url = "path:/home/vivlim/git/viv_nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    nixGL = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nil = { # nix language server
      url = "github:oxalica/nil#";
    };
    mastodon-archive = {
      url = "github:vivlim/mastodon-archive";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, unstable, nixpkgs-vivlim, home-manager, plasma-manager, sops-nix
    , nixGL, nil, mastodon-archive, ... }:
    let
      # configuration = { pkgs, ... }: { nix.package = pkgs.nixflakes; }; # doesn't do anything?
      overlay = final: prev: {
        unstable = unstable.legacyPackages.${prev.system};
        nixpkgs-vivlim = nixpkgs-vivlim.legacyPackages.${prev.system};
      };
      # make pkgs.unstable available in configuration.nix
      overlayModule =
        ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay ]; });

      # builders for rebuild commands
      nixHomeManagerRebuildCommand =
        { configName, repoPath, extraOptions ? [ ], prefix ? "" }:
        let extraOptionsString = nixpkgs.lib.concatStrings extraOptions;

        in ''
          ${prefix} nix --extra-experimental-features nix-command --extra-experimental-features flakes build ${extraOptionsString} ${repoPath}#homeConfigurations."${configName}".activationPackage && ./result/activate && unlink ./result'';
    in {

      homeConfigurations = {
        "vivlim@icebreaker-prime" = home-manager.lib.homeManagerConfiguration rec {
          system = "x86_64-linux";
          extraSpecialArgs = {
            inherit nixpkgs;
            inherit home-manager;
            inherit system;
            inherit nil;
            inherit mastodon-archive;
            bonusShellAliases = {
              nixrb = nixHomeManagerRebuildCommand {
                configName = "vivlim@icebreaker-prime";
                repoPath = "/home/vivlim/git/nix-home";
                extraOptions = [ "--impure" ];
                prefix = "NIXPKGS_ALLOW_UNFREE=1 ";
              };
            };
          };
          configuration = ./modules/shell.nix;
          homeDirectory = "/home/vivlim";
          username = "vivlim";
          extraModules = [
            ./modules/editors_nvim.nix
            ./modules/editors_helix.nix
            ./modules/editors_spacemacs.nix
            ./modules/dev_nix.nix
            ./modules/lsp_nil.nix
            ./modules/gui_art.nix
            ./modules/gui_chat.nix
            ./modules/gui_dev.nix
            ./modules/gui_media.nix
            ./modules/gui_misc.nix
            #./modules/notes_sync.nix
            ./modules/notes_dav.nix
            ./modules/syncthing.nix
            ./plasma
            ./plasma/plasma-manager-config.nix # captured using `nix run github:pjones/plasma-manager`
            plasma-manager.homeManagerModules.plasma-manager
            overlayModule
            ({ mastodon-archive, system, ... }: {
              home.packages = [ mastodon-archive.defaultPackage.${system} ];
            })
          ];
        };
        "vivlim@icebreaker-prime-void" =
          home-manager.lib.homeManagerConfiguration rec {
            system = "x86_64-linux";
            extraSpecialArgs = {
              # inherit inputs;
              inherit nixpkgs;
              inherit home-manager;
              inherit nixGL;
              inherit system;
              #inherit nil;
              # channels = {
              #   inherit unstable;
              #   inherit nixpkgs;
              # };
              bonusShellAliases = {
                nixrb = nixHomeManagerRebuildCommand {
                  configName = "vivlim@icebreaker-prime-void";
                  repoPath = "/home/vivlim/git/nix-home";
                  #extraOptions = [ "--impure" ]; # required for nixGLNvidia
                  #prefix =
                    #"NIXPKGS_ALLOW_UNFREE=1 ";
                };
              };
            };
            configuration = ./modules/shell.nix;
            homeDirectory = "/home/vivlim";
            username = "vivlim";
            extraModules = [
              ./modules/editors_nvim.nix
              ./modules/editors_helix.nix
              ./modules/nixgl.nix
              overlayModule
            ];
          };
        "vivlim@quire" =
          home-manager.lib.homeManagerConfiguration rec {
            system = "x86_64-linux";
            extraSpecialArgs = {
              # inherit inputs;
              inherit nixpkgs;
              inherit home-manager;
              inherit nixGL;
              inherit system;
              #inherit nil;
              # channels = {
              #   inherit unstable;
              #   inherit nixpkgs;
              # };
              bonusShellAliases = {
                nixrb = nixHomeManagerRebuildCommand {
                  configName = "vivlim@quire";
                  repoPath = "/home/vivlim/git/nix-home";
                  extraOptions = [ "--builders ssh://seedling" ];
                  #prefix =
                    #"NIXPKGS_ALLOW_UNFREE=1 ";
                };
              };
            };
            configuration = ./modules/shell.nix;
            homeDirectory = "/home/vivlim";
            username = "vivlim";
            extraModules = [
              ./modules/editors_nvim.nix
              ./modules/editors_helix.nix
              ./modules/nixgl.nix
              overlayModule
            ];
          };

        "vivlim@generic-nixos" = home-manager.lib.homeManagerConfiguration rec {
          system = "x86_64-linux";
          extraSpecialArgs = {
            inherit nixpkgs;
            inherit home-manager;
            inherit system;
            bonusShellAliases = {
              nixrb = nixHomeManagerRebuildCommand {
                configName = "vivlim@generic-nixos";
                repoPath = "/home/vivlim/git/nix-home";
              };
            };
          };
          configuration = ./modules/shell.nix;
          homeDirectory = "/home/vivlim";
          username = "vivlim";
          extraModules = [
            ./modules/editors_nvim.nix
            ./modules/editors_helix.nix
            ./modules/dev_nix.nix
            overlayModule
          ];
        };
        "vivlim@dev" = home-manager.lib.homeManagerConfiguration rec {
          system = "x86_64-linux";
          extraSpecialArgs = {
            inherit nixpkgs;
            inherit home-manager;
            inherit system;
            inherit nil;
            bonusShellAliases = {
              nixrb = nixHomeManagerRebuildCommand {
                configName = "vivlim@dev";
                repoPath = "/home/vivlim/git/nix-home";
              };
            };
          };
          configuration = ./modules/shell.nix;
          homeDirectory = "/home/vivlim";
          username = "vivlim";
          extraModules = [
            ./modules/editors_nvim.nix
            ./modules/editors_helix.nix
            ./modules/dev_nix.nix
            ./modules/lsp_nil.nix
            overlayModule
          ];
        };
        "vivlim@vix" = home-manager.lib.homeManagerConfiguration rec {
          system = "x86_64-linux";
          extraSpecialArgs = {
            inherit nixpkgs;
            inherit home-manager;
            inherit system;
            inherit nil;
            inherit mastodon-archive;
            bonusShellAliases = {
              nixrb = nixHomeManagerRebuildCommand {
                configName = "vivlim@vix";
                repoPath = "/home/vivlim/git/nix-home";
                extraOptions = [ "--impure" ];
                prefix = "NIXPKGS_ALLOW_UNFREE=1 ";
              };
            };
          };
          configuration = ./modules/shell.nix;
          homeDirectory = "/home/vivlim";
          username = "vivlim";
          extraModules = [
            ./modules/editors_nvim.nix
            ./modules/editors_helix.nix
            ./modules/dev_nix.nix
            ./modules/lsp_nil.nix
            ./modules/gui_chat.nix
            ./modules/gui_media.nix
            ./modules/gui_misc.nix
            #./modules/notes_sync.nix
            ./modules/notes_dav.nix
            ./modules/syncthing.nix
            overlayModule
            ({ mastodon-archive, system, ... }: {
              home.packages = [ mastodon-archive.defaultPackage.${system} ];
            })
          ];
        };
        "vivlim@gui" = home-manager.lib.homeManagerConfiguration rec {
          system = "x86_64-linux";
          extraSpecialArgs = {
            inherit nixpkgs;
            inherit home-manager;
            inherit system;
            inherit nil;
            inherit mastodon-archive;
            bonusShellAliases = {
              nixrb = nixHomeManagerRebuildCommand {
                configName = "vivlim@gui";
                repoPath = "/home/vivlim/git/nix-home";
                extraOptions = [ "--impure" ];
                prefix = "NIXPKGS_ALLOW_UNFREE=1 ";
              };
            };
          };
          configuration = ./modules/shell.nix;
          homeDirectory = "/home/vivlim";
          username = "vivlim";
          extraModules = [
            ./modules/editors_nvim.nix
            ./modules/editors_helix.nix
            ./modules/dev_nix.nix
            ./modules/lsp_nil.nix
            ./modules/gui_chat.nix
            ./modules/gui_media.nix
            ./modules/gui_misc.nix
            overlayModule
            ({ mastodon-archive, system, ... }: {
              home.packages = [ mastodon-archive.defaultPackage.${system} ];
            })
          ];
        };
        "vivlim@macaroni-tome" = home-manager.lib.homeManagerConfiguration rec {
          system = "aarch64-darwin";
          extraSpecialArgs = {
            inherit nixpkgs;
            inherit home-manager;
            inherit system;
            inherit nil;
            bonusShellAliases = {
              nixrb = nixHomeManagerRebuildCommand {
                configName = "vivlim@macaroni-tome";
                repoPath = "/Users/vivlim/git/nix-home";
              };
            };
          };
          configuration = ./modules/shell.nix;
          homeDirectory = "/Users/vivlim";
          username = "vivlim";
          extraModules = [
            ./modules/editors_nvim.nix
            ./modules/editors_helix.nix
            ./modules/dev_nix.nix
            ./modules/dev_racket.nix
            overlayModule
          ];
        };
      };
    };
}
