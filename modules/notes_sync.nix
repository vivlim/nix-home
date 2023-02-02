{ pkgs, system, channels, ... }: {
  services.git-sync = {
    enable = true;
    repositories = {
      "notes" = {
        interval = 500; # seconds
        path = "/home/vivlim/notes";
        uri = "vivlim@vix.cow-bebop.ts.net:notes.git";
      };
    };
  };

  home.packages = with pkgs; [
    git-sync
  ];
}
