# viv's nix home-manager flake

this is a work in progress. i'm separating my home-manager stuff out from a massive flake I have all of my other machine configs in.

the main motivator of this is not needing to update which commit of unstable my servers are pointing to when I need to update my discord client to be able to keep using it :)))))

## aliases

`nixrb`: rebuild the activation package from this flake and run it

## how to get a machine to use this

1. add a config for the machine in flake.nix or select one

2. `nix --extra-experimental-features nix-command --extra-experimental-features flakes build  .#homeConfigurations.\"${configName}\".activationPackage`

3. if that succeeded, `./result/activate` and resolve conflicts if any

4. `source ~/.bashrc` (or open new terminal) and now you can use the alias `nixrb` to rebuild & activate.
