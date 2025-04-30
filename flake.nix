{
  description = "Alark's NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #hyprland = {
    #    url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    #    inputs.nixpkgs.follows = "nixpkgs";
    #};
		systems.url = "github:nix-systems/default";
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
    };
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    nixcord.url = "github:kaylorben/nixcord";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    neovim.url = "github:alarkworthy/neovim";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    inputs@{
      self,
      systems,
			treefmt-nix,
		  nixpkgs,
		  nixpkgs-xr,
		  neovim,
		  nix-gaming,
		  home-manager,
		  impermanence,
		  chaotic,
		  stylix,
		  nixcord,
      ...
    }:
    let
      forAllSystems =
        f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
      treefmtEval = forAllSystems (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);

      overlays = [
        nixpkgs-xr.overlays.default
        neovim.overlays.default
      ];
     nixosModules = [
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
        chaotic.nixosModules.default
        nixpkgs-xr.nixosModules.nixpkgs-xr
        nix-gaming.nixosModules.pipewireLowLatency
        #{
        #  home-manager.useGlobalPkgs = true;
        #  home-manager.useUserPackages = true;
        #}
        stylix.nixosModules.stylix
        #hyprland.nixosModules.default
      ];

      homesModules = [
        #hyprland.homeManagerModules.default
        nixcord.homeManagerModules.nixcord
        chaotic.homeManagerModules.default
      ];
    in
    {
			nixosConfigurations = {
				lapdog = nixpkgs.lib.nixosSystem {
					system = "x86_64-linux";
					specialArgs = {
						inherit inputs;
					};
				};
			};
      # nix fmt
      formatter = forAllSystems (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
			# nix flake check
      checks = forAllSystems (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });

    };
}
