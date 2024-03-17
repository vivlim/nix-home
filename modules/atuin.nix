{ pkgs, config, lib, system, bonusShellAliases ? {}, ... }: {

  programs.atuin = {
    enable = true;
    settings = {
      update_check = false;
      prefers_reduced_motion = true;
      keymap_mode = "vim-insert"; # esc switches to 'normal' mode
      style = "auto";
      inline_height = 40;
      key_path = "$XDG_RUNTIME_DIR/secrets/atuin_key"; #config.sops.secrets.atuin_key.path;
    };
  };

  sops.secrets.atuin_key = {
    sopsFile = ../secrets/atuin.yaml;
  };
}
