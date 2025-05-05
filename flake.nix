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
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
    };
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
    {
      self,
      systems,
      nixpkgs-xr,
      ...
    }@inputs:
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
        # (final: prev:{
        # 	xrizer1 = prev.xrizer.overrideAttrs (prevAttrs: rec {
        # 			version = "2a54e25bfac72afe4b695c7045dfb349efad76ed";
        # 			src = prev.fetchFromGitHub {
        # 				owner = "SpookySkeletons";
        # 				repo = "xrizer";
        # 				rev = version;
        # 				hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        # 			};
        # 			cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        # 		});
        # 	})
        nixpkgs-xr.overlays.default
        neovim.overlays.default
        # postUnpack = ''
        #   # Ensure revision consistency between the fetched Monado and CMakeLists.txt
        #   ourMonadoRev="${previousMonadoAttrs.src.rev}"
        #   theirMonadoRev=$(sed -n '/FetchContent_Declare(monado/,/)/p' ${previousMonadoAttrs.src.name}/CMakeLists.txt | grep "GIT_TAG" | awk '{print $2}')
        #   if [ ! "$theirMonadoRev" == "$ourMonadoRev" ]; then
        #     echo "Our Monado source revision doesn't match CMakeLists.txt." >&2
        #     echo "  theirs: $theirMonadoRev" >&2
        #     echo "    ours: $ourMonadoRev" >&2
        #     return 1
        #   fi
        # '';

        # (final: prev: {
        #   wivrn = prev.wivrn.overrideAttrs (previousAttrs: rec {
        #      version = "Latest-solarXR";
        #      src = prev.fetchFromGitHub {
        #        owner = "notpeelz";
        #        repo = "WiVRn";
        # rev = "ae3231708fe4d2d8270cfb7be2bb7b061b8e4425";
        # hash = "sha256-bvwCIytlIDy14gk1dAgaa5jvose1PSMHuTchbvyneeM=";
        # #Previous rev and hash that worked with solarxr patches
        # #rev = "8ce86763d46206f191bc0235ca0af5410e0b220c";
        # #hash = "sha256-G8k52LbgNk1pbTy5ehs+ZMI7L3mOsGFFt3cyFF2hN6c=";
        #      };
        #     cmakeFlags = (previousAttrs.cmakeFlags or [ ]) ++ [
        #       (nixpkgs.lib.cmakeBool "WIVRN_FEATURE_SOLARXR" true)
        #     ];
        #   });
        # })
        # (final: prev:
        # {
        # 			slimevr = prev.slimevr.overrideAttrs (previousAttrs: rec {
        #     version = "123";
        #     src = prev.fetchFromGitHub {
        #       owner = "SlimeVR";
        #       repo = "SlimeVR-Server";
        #       rev = "d3b2cb726b077a28b1cffc72d635eabf0d66a38b";
        # 						#"4f364acecc98ccad4a20f0155a2f806d6fb98e0d";
        #       hash = "sha256-nPAIwykY/8tXa3ISUD+c7HmOtY7iurpd2jS95GGgyjU=";
        # 		#"sha256-9oMdxuP/TpZn2GOkXeLxKBsnxZ4bFIwJgPM8rPTvzbE=";
        #
        #     };
        #   });
        # })
      ];
      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
        chaotic.nixosModules.default
        nixpkgs-xr.nixosModules.nixpkgs-xr
        nix-gaming.nixosModules.pipewireLowLatency
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
