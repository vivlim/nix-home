{ pkgs, system, channels, ... }: {
  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
    };
  };
}
