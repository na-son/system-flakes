{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:na-son/unified";
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
      imports = [
        inputs.nixos-flake.flakeModule
      ];

      flake =
        let
          myUserName = "nason";
        in
        {
          # Configurations for Linux (NixOS) machines
          nixosConfigurations = {
            hecate = self.nixos-flake.lib.mkLinuxSystem {
              nixpkgs.hostPlatform = "x86_64-linux";
              imports = [
                self.nixosModules.common # See below for "nixosModules"!
                self.nixosModules.linux
                # Your machine's configuration.nix goes here
                ({ pkgs, ... }: {
                  # TODO: Put your /etc/nixos/hardware-configuration.nix here
                  boot.loader.grub.device = "nodev";
                  fileSystems."/" = {
                    device = "/dev/disk/by-label/nixos";
                    fsType = "btrfs";
                  };
                  system.stateVersion = "23.05";
                })
                # Your home-manager configuration
                self.nixosModules.home-manager
                {
                  home-manager.users.${myUserName} = {
                    imports = [
                      self.homeModules.common # See below for "homeModules"!
                      self.homeModules.linux
                    ];
                    home.stateVersion = "22.11";
                  };
                }
              ];
            };
          };

          # Configurations for macOS machines
          darwinConfigurations = {
            luna = self.nixos-flake.lib.mkMacosSystem {
              nixpkgs.hostPlatform = "aarch64-darwin";
              imports = [
                self.nixosModules.common # See below for "nixosModules"!
                self.nixosModules.darwin
                # Your machine's configuration.nix goes here
                ({ pkgs, ... }: {
                  services.nix-daemon.enable = true;

                  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
                  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
                  system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
                  system.defaults.NSGlobalDomain.KeyRepeat = 1;
                  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
                  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
                  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
                  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
                  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
                  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
                  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
                  system.defaults.NSGlobalDomain._HIHideMenuBar = false;
                
                  system.defaults.dock.autohide = true;
                  system.defaults.dock.mru-spaces = false;
                  system.defaults.dock.orientation = "bottom";
                  system.defaults.dock.showhidden = true;
                
                  system.defaults.finder.AppleShowAllExtensions = true;
                  system.defaults.finder.QuitMenuItem = true;
                  system.defaults.finder.FXEnableExtensionChangeWarning = false;
                
                  system.defaults.trackpad.Clicking = true;
                  system.defaults.trackpad.TrackpadThreeFingerDrag = true;
                
                  services.yabai.enable = true;
                  services.yabai.package = pkgs.yabai;
                  services.skhd.enable = true;

                  system.stateVersion = 4;
                })
                # Your home-manager configuration
                self.darwinModules.home-manager
                {
                  home-manager.users.${myUserName} = {
                    imports = [
                      self.homeModules.common # See below for "homeModules"!
                      self.homeModules.darwin
                    ];
                    home.stateVersion = "22.11";
                  };
                }
              ];
            };
          };

          # All nixos/nix-darwin configurations are kept here.
          nixosModules = {
            # Common nixos/nix-darwin configuration shared between Linux and macOS.
            common = { pkgs, ... }: {
              nixpkgs.config.allowUnfree = true;
              environment.systemPackages = with pkgs; [
                vim
              ];
            };
            # NixOS specific configuration
            linux = { pkgs, ... }: {
              users.users.${myUserName}.isNormalUser = true;
              services.netdata.enable = true;
            };
            # nix-darwin specific configuration
            darwin = { pkgs, ... }: {
              security.pam.enableSudoTouchIdAuth = true;
            };
          };

          # All home-manager configurations are kept here.
          homeModules = {
            # Common home-manager configuration shared between Linux and macOS.
            common = { pkgs, ... }: {
              programs.git.enable = true;
              programs.zsh.enable = true;
            };
            # home-manager config specific to NixOS
            linux = {
              xsession.enable = true;
            };
            # home-manager config specifi to Darwin
            darwin = {
              targets.darwin.search = "Google";
            };
          };
        };
    };
}

