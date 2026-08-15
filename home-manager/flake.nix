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
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "path:/Users/al/dotfiles";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, llm-agents, nixvim, nix-darwin, dotfiles, ... }:
    let
      system = "aarch64-darwin";
      # The overlay and allowUnfree are baked in here because home-manager
      # runs with useGlobalPkgs and no nixpkgs module of its own.
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ llm-agents.overlays.shared-nixpkgs ];
      };
    in {
      # Single entry point: `sudo darwin-rebuild switch` activates the system
      # config (./darwin.nix) and home-manager (./home.nix, ./nvim.nix).
      # Named after the hostname: bare darwin-rebuild resolves the default
      # attribute as darwinConfigurations.<LocalHostName>, and discovers
      # this flake via /etc/nix-darwin/flake.nix (a symlink to this file).
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
