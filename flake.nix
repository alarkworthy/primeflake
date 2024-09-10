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
    };

#   outputs = inputs:
#       inputs.snowfall-lib.mkFlake {
#           # You must provide our flake inputs to Snowfall Lib.
#           inherit inputs;

#           # The `src` must be the root of the flake. See configuration
#           # in the next section for information on how you can move your
#           # Nix files to a separate directory.
#           src = ./.;
#           
#           snowfall = {
#             namespace = "Pluto";
#           };

#           home.users."alark@gamersUnited".modules = with inputs; [
#            snowfall-lib.homeModules.user
#           ];

#           systems.modules.nixos = with inputs; [
#             home-manager.nixosModules.home-manager
#           ];
#           
#           
#       };


    outputs = {self, systems, ...}@inputs: 
    let
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
                    allowUnfree = true; #Allow unfree packages
                };
            

                #overlays = with inputs; [];
                systems.modules.nixos = with inputs; [
                    home-manager.nixosModules.home-manager
                    impermanence.nixosModules.impermanence
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
                ];



            };
}
