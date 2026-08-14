{
  description = "Home Manager configuration of anatoli.liotych";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "path:/Users/al/dotfiles";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, llm-agents, nixvim, dotfiles, ... }:
    let
      inherit (nixpkgs) lib;
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."al" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit dotfiles; };

        modules = [
          {
            nixpkgs.overlays = [
              llm-agents.overlays.shared-nixpkgs
            ];
          }
          nixvim.homeModules.nixvim
          ./home.nix
          ./nvim.nix
        ];
      };
    };
}
