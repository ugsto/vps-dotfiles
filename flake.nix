{
  description = "My VPS dotfiles!";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      nixpkgs,
      disko,
      ...
    }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      username = "kurisu";
      name = "André Augusto Bortoli";
      hostname = "steins-gate";
    in
    {
      nixosConfigurations = {
        ${hostname} = lib.nixosSystem {
          specialArgs = {
            inherit
              system
              username
              name
              hostname
              ;
          };
          modules = [
            disko.nixosModules.disko
            ./system/configuration.nix
          ];
        };
      };
    };
}
