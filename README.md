# WIP

Install nix (determinate systems)

Clone repo

## Macos

The determinate systems installer configures `/etc/nix/nix.conf`, but `nix-darwin` wishes to control this file.
It's a bit awkward at the moment.

```shell
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.orig
nix run nix-darwnin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .#luna
```

Nixos is simpler.

```shell
nixos-rebuild switch --flake .#hecate
```
