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
      nixpkgs.hostPlatform = "aarch64-darwin";
      nix.package = pkgs.nix;
      nix.settings.experimental-features = "nix-command flakes";
      services.nix-daemon.enable = true;

      system.stateVersion = 4;
      system.configurationRevision = self.rev or self.dirtyRev or null;

      programs.zsh.enable = true;

      users.users.nason.home = "/Users/nason"; # TODO: set username here
    };
  in
  {
    # $ darwin-rebuild switch --flake .#luna
    darwinConfigurations."luna" = nix-darwin.lib.darwinSystem {
      modules = [ 
        ./darwin.nix

        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.nason = import ./home.nix; # TODO: add your username here!
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."luna".pkgs;
  };
}
