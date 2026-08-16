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
    tuicr = {
      url = "github:agavra/tuicr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      llm-agents,
      nixvim,
      nix-darwin,
      tuicr,
      ...
    }:
    let
      system = "aarch64-darwin";
      user = "al";
      hostname = "stardusty";
      gitName = "Anatoli Liotych";
      gitEmail = "anatoli.liotych@gmail.com";
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;

      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit nix-darwin user; };
        modules = [
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [ llm-agents.overlays.shared-nixpkgs ];
          }
          ./nix/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              extraSpecialArgs = {
                dotfiles = self;
                tuicr = tuicr.packages.${system}.default;
                inherit user gitName gitEmail;
              };
              users.${user} = {
                imports = [
                  nixvim.homeModules.nixvim
                  ./nix/git.nix
                  ./nix/home.nix
                  ./nix/mole.nix
                  ./nix/nvim.nix
                  ./nix/opensuperwhisper.nix
                  ./nix/services.nix
                  ./nix/tmux.nix
                  ./nix/zsh.nix
                ];
              };
            };
          }
        ];
      };
    };
}
