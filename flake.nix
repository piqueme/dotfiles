{
  description = "System and user environment Nix configurations";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
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
            }
          ];
        };
      };
    };
}
