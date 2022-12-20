# how to bring up new non-nixos machines

1. add a config for the machine in flake.nix

2. `nix --extra-experimental-features nix-command --extra-experimental-features flakes build  .#homeConfigurations.\"${configName}\".activationPackage`

3. if that succeeded, `./result/activate` and resolve conflicts if any

4. `source ~/.bashrc` (or open new terminal) and now you can use the alias `nixrb` to rebuild & activate.
