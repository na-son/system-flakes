# My personal system flakes

Currently only contains my new `nix-darwin` config, working on integrating
my nixos and `home-manager` configs.


## Getting started
Install nix.

```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

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

