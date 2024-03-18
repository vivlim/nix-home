{ pkgs, lib, config, inputs, ... }: {
  nixpkgs.overlays = [ inputs.android-nixpkgs.overlays.default ];
  imports = [
    inputs.android-nixpkgs.hmModule
    {
      android-sdk.enable = true;

      android-sdk.packages = sdk:
        with sdk; [
          build-tools-34-0-0
          cmdline-tools-latest
          #emulator
          platforms-android-34
          #sources-android-34
        ];
    }
  ];
}
