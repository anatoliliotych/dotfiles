{
  description = "Home Manager configuration of anatoli.liotych";

  inputs = {
    # Flake inputs cannot reference variables (flake.nix must be a literal
    # attrset), so bump all four 26.05 refs together on release upgrades.
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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      llm-agents,
      nixvim,
      nix-darwin,
      ...
    }:
    let
      system = "aarch64-darwin";
      user = "al";
      hostname = "stardusty";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ llm-agents.overlays.shared-nixpkgs ];
      };
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;

      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system pkgs;
        specialArgs = { inherit nix-darwin user; };
        modules = [
          ./nix/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              extraSpecialArgs = {
                dotfiles = self;
                inherit user;
              };
              users.${user} = {
                imports = [
                  nixvim.homeModules.nixvim
                  ./nix/home.nix
                  ./nix/nvim.nix
                ];
              };
            };
          }
        ];
      };
    };
}
