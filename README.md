# WIP

Install nix (determinate systems)

Clone repo

## Macos

The determinate systems installer configures `/etc/nix/nix.conf`, but `nix-darwin` wishes to control this file.
It's a bit awkward at the moment.

```shell
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.orig
mkdir -p ~/.config/nix-darwin
cd ~/.config/nix-darwin
git clone github.com/na-son/system-flakes .
nix run nix-darwnin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .#luna
```
Open a new terminal, and run

```shell
cd ~/.config/nix/darwin
darwin-rebuild switch --flake .#luna
```

Nixos is simpler.

```shell
nixos-rebuild switch --flake .#hecate
```
