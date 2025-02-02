{
  description = "Pluto";

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
		nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    nixcord.url = "github:kaylorben/nixcord";
    #jovian = {
    #    url = "github:Jovian-Experiments/Jovian-NixOS";
    #    inputs.nixpkgs.follows = "nixpkgs";
    #};
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    neovim.url = "github:alarkworthy/neovim";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
  #   outputs = inputs:
  #       inputs.snowfall-lib.mkFlake {
  #           # You must provide our flake inputs to Snowfall Lib.
  #           inherit inputs;

  #           # The `src` must be the root of the flake. See configuration
  #           # in the next section for information on how you can move your
  #           # Nix files to a separate directory.
  #           src = ./.;

  #           snowfall = {
  #             namespace = "Pluto";
  #           };

  #           home.users."alark@gamersUnited".modules = with inputs; [
  #            snowfall-lib.homeModules.user
  #           ];

  #           systems.modules.nixos = with inputs; [
  #             home-manager.nixosModules.home-manager
  #           ];

  #       };

  outputs =
    { self, systems, nixpkgs-xr, ... }@inputs:
    let
      forAllSystems =
        f: inputs.nixpkgs.lib.genAttrs (import systems) (system: f inputs.nixpkgs.legacyPackages.${system});
      treefmtEval = forAllSystems (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);

      liba = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "pluto";
            title = "Pluto";
          };
          namespace = "pluto";
        };
      };
    in
    liba.mkFlake {
      channels-config = {
        allowUnfree = true; # Allow unfree packages
      };

      overlays = with inputs; [
				nixpkgs-xr.overlays.default
        neovim.overlays.default
      ];
      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
        chaotic.nixosModules.default
				nixpkgs-xr.nixosModules.nixpkgs-xr
        #jovian.nixosModules.default
        #{
        #  home-manager.useGlobalPkgs = true;
        #  home-manager.useUserPackages = true;
        #}
        stylix.nixosModules.stylix
        #hyprland.nixosModules.default
      ];

      homes.modules = with inputs; [
        #hyprland.homeManagerModules.default
        nixcord.homeManagerModules.nixcord
				chaotic.homeManagerModules.default
      ];

    }
    // {
      formatter = forAllSystems (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
      checks = forAllSystems (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });

    };
}
