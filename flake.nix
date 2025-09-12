{
  description = "System and user environment Nix configurations";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      # TODO: Deduplicate with configuration.nix.
      unfree = [
        "discord" 
        "claude-code"
      ];
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = (pkg:
          builtins.elem (pkg.pname or (builtins.parseDrvName pkg.name).name) unfree
        );
      };
    in {
      defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
      homeConfigurations = {
        "obe" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./nixos/home.nix ];
        };
      };
      nixosConfigurations = {
        "obe-shard" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ 
            ./nixos/configuration.nix 
            home-manager.nixosModules.home-manager {
              home-manager.users.obe = import ./nixos/home.nix;
              home-manager.useGlobalPkgs = true;
            }
          ];
        };
      };
    };
}
