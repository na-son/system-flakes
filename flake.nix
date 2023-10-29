{
  description = "luna";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };



outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # Auto upgrade nix package and the daemon service.
      nixpkgs.hostPlatform = "aarch64-darwin";
      nix.package = pkgs.nix;
      nix.settings.experimental-features = "nix-command flakes";
      services.nix-daemon.enable = true;

      system.stateVersion = 4;
      system.configurationRevision = self.rev or self.dirtyRev or null;

      programs.zsh.enable = true;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#luna
    # Or switch using:
    # $ darwin-rebuild switch --flake .#luna
    darwinConfigurations."luna" = nix-darwin.lib.darwinSystem {
      modules = [ ./darwin.nix ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."luna".pkgs;
  };
}

