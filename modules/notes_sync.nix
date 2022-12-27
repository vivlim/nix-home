{ pkgs, system, channels, ... }: {
  services.git-sync = {
    enable = true;
    repositories = {
      "notes" = {
        interval = 500; # seconds
        path = "/home/vivlim/notes";
        uri = "file:///dev/null"; # clone it manually
      };
    };
  };
}
