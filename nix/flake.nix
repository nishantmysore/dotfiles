{
  description = "Nishant's nix configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix";
    };
  };
  outputs = { self, nixpkgs, nix-darwin, home-manager, claude-code }:
  let
    darwinHost = { name, homeModule, system ? "aarch64-darwin", extraModules ? [ ] }:
      nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { hostName = name; };
        modules = [
          ./configuration.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs.overlays = [ claude-code.overlays.default ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users."nishant.mysore" = import homeModule;
          }
        ] ++ extraModules;
      };

    nixosHost = { system ? "x86_64-linux" }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hardware-configuration-server.nix
          ./nixos-server.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ claude-code.overlays.default ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.nishant = import ./home-linux.nix;
          }
        ];
      };
  in
  {
    darwinConfigurations = {
      personal-mac = darwinHost {
        name = "personal-mac";
        homeModule = ./home-personal-mac.nix;
      };

      work-macbook = darwinHost {
        name = "work-macbook";
        homeModule = ./home-work-macbook.nix;
        extraModules = [
          {
            nixpkgs = {
              config.segger-jlink.acceptLicense = true;
              overlays = [
                (final: prev: {
                  arm-toolchain-for-embedded = final.callPackage ./pkgs/arm-toolchain-for-embedded.nix { };
                })
              ];
            };
          }
        ];
      };
    };

    nixosConfigurations = {
      server = nixosHost { };
      nishraptorserver = nixosHost { };
    };
  };
}
