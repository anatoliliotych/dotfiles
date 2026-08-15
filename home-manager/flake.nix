{
  description = "Home Manager configuration of anatoli.liotych";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "path:../";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, llm-agents, nixvim, nix-darwin, dotfiles, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ llm-agents.overlays.shared-nixpkgs ];
      };
    in {
      darwinConfigurations."stardusty" = nix-darwin.lib.darwinSystem {
        inherit system pkgs;
        specialArgs = { inherit nix-darwin; };
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              extraSpecialArgs = { inherit dotfiles; };
              users.al = {
                imports = [
                  nixvim.homeModules.nixvim
                  ./home.nix
                  ./nvim.nix
                ];
              };
            };
          }
        ];
      };
    };
}
