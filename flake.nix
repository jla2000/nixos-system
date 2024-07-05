{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-dotfiles.url = "github:jla2000/nixos-dotfiles";
    nur.url = "github:nix-community/nur";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.nur.outputs.overlay
        ];
      };
    in
    {
      nixosConfigurations."zephyrus" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgs; };
        modules = [
          ./zephyrus/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.users.jan = import ./zephyrus/home.nix;
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
}
