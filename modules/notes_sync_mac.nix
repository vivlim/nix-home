{ pkgs, system, channels, ... }: {
  launchd.enable = true;
  services.git-sync = {
    enable = true;
    repositories = {
      "notes" = {
        interval = 500; # seconds
        path = "/Users/vivlim/notes";
        uri = "file:///dev/null"; # clone it manually
      };
    };
  };
}
